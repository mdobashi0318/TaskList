//
//  EditTaskScreen.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/04/02.
//

import SwiftUI

struct EditTaskScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) var modelContext
    
    @State var model: TaskModel
    
    @State private var isSetStartDate = false
    
    @State private var isSetEndDate = false
    
    @State private var isValidation = false
    @State private var validationMessage = "未入力箇所があります。"
    
    init(model: TaskModel) {
        _model = State(initialValue: model)
        _isSetStartDate = State(initialValue: model.startDate != nil)
        _isSetEndDate = State(initialValue: model.deadline != nil)
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                Section(content: {
                    TextField(R.string.message.inputTitle(), text: $model.title)
                }, header: {
                    Text(R.string.label.title())
                })
                
                Section(content: {
                    TextField(R.string.message.inputDetail(), text: $model.detail)
                }, header: {
                    Text(R.string.label.detail())
                })
                
                Section(content: {
                    Toggle(R.string.message.isSetStartDate(), isOn: $isSetStartDate)
                    
                    if isSetStartDate {
                        DatePicker(R.string.message.inputStartDate(), selection: $model.noSaveStartDate)
                    }
                    
                    Toggle(R.string.message.isSetDeadline(), isOn: $isSetEndDate)
                    
                    if isSetEndDate {
                        DatePicker(R.string.message.inputDeadline(), selection: $model.noSaveDeadline)
                    }
                    
                }, header: {
                    Text(R.string.label.date())
                })
                
                
                Section(content: {
                    Picker(R.string.label.priority(), selection: $model.priority) {
                        ForEach(Prioritys.allCases) {
                            Text($0.title)
                                .tag($0)
                        }
                    }
                })
                
                
            }
            .navigationTitle(R.string.screenTitle.editTaskScreen())
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CloseButton(action: {
                        modelContext.rollback()
                        dismiss()
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        updateTask()
                    }, label: {
                        Text(R.string.button.done())
                    })
                }
            }
            .alert(validationMessage, isPresented: $isValidation, actions: {
                Button(role: .cancel, action: {
                    isValidation.toggle()
                }, label: {
                    Text(R.string.button.close())
                })
            })
        }
    }
    
    
    private func updateTask() {
        if model.title.isEmpty {
            validationMessage = R.string.message.inputTitle()
            isValidation = true
            return
        } else if model.detail.isEmpty {
            validationMessage = R.string.message.inputDetail()
            isValidation = true
            return
        }
        
        do {
            model.update(isSetStartDate: isSetStartDate, isSetEndDate: isSetEndDate)
            try modelContext.save()
            dismiss()
        } catch {
            validationMessage = "更新に失敗しました"
            isValidation = true
        }
        
        
    }
}
