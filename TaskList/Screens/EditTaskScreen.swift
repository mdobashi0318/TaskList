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
    @State private var startDate: Date = Date()
    
    @State private var isSetEndDate = false
    @State private var endDate: Date = Date()
    

    @State private var isValidation = false
    @State private var validationMessage = "未入力箇所があります。"
    
    init(model: TaskModel) {
        _model = State(initialValue: model)
        _isSetStartDate = State(initialValue: model.startDate != nil)
        _isSetEndDate = State(initialValue: model.deadline != nil)
        _startDate = State(initialValue: DateFormatter.format_yyyyMMddHHmm_str(model.startDate ?? ""))
        _endDate = State(initialValue: DateFormatter.format_yyyyMMddHHmm_str(model.deadline ?? ""))
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                Section(content: {
                    TextField("タイトルを入力してください", text: $model.title)
                }, header: {
                    Text("タイトル")
                })
                
                Section(content: {
                    TextField("タイトルを入力してください", text: $model.detail)
                }, header: {
                    Text("詳細")
                })
                
                Section(content: {
                    Toggle("開始日時をセットする", isOn: $isSetStartDate)
                    
                    if isSetStartDate {
                        DatePicker("開始日時を選択してください", selection: $startDate)
                    }
                    
                    Toggle("期日をセットする", isOn: $isSetEndDate)
                    
                    if isSetEndDate {
                        DatePicker("期日を選択してください", selection: $endDate)
                    }
                    
                }, header: {
                    Text("日時")
                })
                
                
                Section(content: {
                    Picker("優先順位", selection: $model.priority) {
                        ForEach(Prioritys.allCases) {
                            Text($0.title)
                                .tag($0)
                        }
                    }
                }, header: {
                    Text("日時")
                })
                
                
            }
            .navigationTitle("追加")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        addTask()
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .alert(validationMessage, isPresented: $isValidation, actions: {
                Button(role: .cancel, action: {
                    isValidation.toggle()
                }, label: {
                    Text("閉じる")
                })
            })
        }
    }
    
    
    private func addTask() {
        if model.title.isEmpty {
            validationMessage = "タイトルを入力してください。"
            isValidation = true
            return
        } else if model.detail.isEmpty {
            validationMessage = "詳細を入力してください"
            isValidation = true
            return
        }
        
        do {
            model.update(startDate: isSetStartDate ? DateFormatter.format_yyyyMMddHHmm(startDate) : nil,
                          deadline: isSetEndDate ? DateFormatter.format_yyyyMMddHHmm(endDate) : nil,
                          tag: "")
            
            modelContext.insert(model)
            try modelContext.save()
            dismiss()
        } catch {
            validationMessage = "追加に失敗しました"
            isValidation = true
        }
        
        
    }
}
