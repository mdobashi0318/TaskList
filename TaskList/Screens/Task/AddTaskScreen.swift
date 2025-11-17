//
//  AddTaskScreen.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/03/23.
//

import SwiftUI
import SwiftData

struct AddTaskScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) var modelContext
    
    var model: TaskModel?
    
    
    @State private var title: String = ""
    
    @State private var detail: String = ""
    
    @State private var isSetStartDate = false
    @State private var startDate: Date = Date()
    
    @State private var isSetEndDate = false
    @State private var endDate: Date = Date()
    
    @State private var priority: Prioritys = .none
    
    @State private var isValidation = false
    @State private var validationMessage = R.string.message.notYetEntered()
    
    @AppStorage(UserDefaults.Key.addFirstTask.rawValue) private var addFirstTask: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(content: {
                    TextField(R.string.message.inputTitle(), text: $title)
                }, header: {
                    Text(R.string.label.title())
                })
                
                Section(content: {
                    TextField(R.string.message.inputDetail(), text: $detail, axis: .vertical)
                }, header: {
                    Text(R.string.label.detail())
                })
                
                Section(content: {
                    Toggle(R.string.message.isSetStartDate(), isOn: $isSetStartDate)
                    
                    if isSetStartDate {
                        DatePicker(R.string.message.inputStartDate(), selection: $startDate)
                    }
                    
                    Toggle(R.string.message.isSetDeadline(), isOn: $isSetEndDate)
                    
                    if isSetEndDate {
                        DatePicker(R.string.message.inputDeadline(), selection: $endDate)
                    }
                    
                }, header: {
                    Text(R.string.label.date())
                })
                
                
                Section(content: {
                    Picker(R.string.label.priority(), selection: $priority) {
                        ForEach(Prioritys.allCases) {
                            Text($0.title)
                                .tag($0)
                        }
                    }
                })
                
                
            }
            .navigationTitle(R.string.screenTitle.addTaskScreen())
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CloseButton(action: {
                        dismiss()
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    AddButton(action: {
                        addTask()
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
    
    
    private func addTask() {
        if title.isEmpty {
            validationMessage = R.string.message.inputTitle()
            isValidation = true
            return
        } else if detail.isEmpty {
            validationMessage = R.string.message.inputDetail()
            isValidation = true
            return
        }
        
        do {
            let taskModel = TaskModel()
            taskModel.add(title: title,
                          detail: detail,
                          startDate: isSetStartDate ? DateFormatter.format_yyyyMMddHHmm(startDate) : nil,
                          deadline: isSetEndDate ? DateFormatter.format_yyyyMMddHHmm(endDate) : nil,
                          priority: priority.rawValue)
            
            modelContext.insert(taskModel)
            try modelContext.save()
            
            if !addFirstTask {
                addFirstTask = true
            }
            dismiss()
        } catch {
            validationMessage = R.string.message.addError()
            isValidation = true
        }
        
        
    }
}
