//
//  AddSubTaskScreen.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/04/06.
//

import SwiftUI
import SwiftData

struct AddSubTaskScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) var modelContext
    
    @Bindable var taskModel: TaskModel
    
    @State private var title: String = ""
    
    @State private var detail: String = ""
    
    @State private var isSetStartDate = false
    @State private var startDate: Date = Date()
    
    @State private var isSetEndDate = false
    @State private var endDate: Date = Date()
    
    @State private var priority: Prioritys = .none
    
    @State private var isValidation = false
    @State private var validationMessage = "未入力箇所があります。"
    
    var body: some View {
        NavigationStack {
            List {
                Section(content: {
                    TextField("タイトルを入力してください", text: $title)
                }, header: {
                    Text("タイトル")
                })
                
                Section(content: {
                    TextField("タイトルを入力してください", text: $detail)
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
                    Picker("優先順位", selection: $priority) {
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
                    Text("閉じる")
                })
            })
        }
    }
    
    
    private func addTask() {
        if title.isEmpty {
            validationMessage = "タイトルを入力してください。"
            isValidation = true
            return
        } else if detail.isEmpty {
            validationMessage = "詳細を入力してください"
            isValidation = true
            return
        }
        
        do {
            let subTask = SubTask()
            subTask.add(title: title,
                        detail: detail,
                        parentTask: taskModel,
                        startDate: isSetStartDate ? DateFormatter.format_yyyyMMddHHmm(startDate) : nil,
                        deadline: isSetEndDate ? DateFormatter.format_yyyyMMddHHmm(endDate) : nil,
                        priority: priority.rawValue,
                        tag: "")
            
            modelContext.insert(subTask)
            taskModel.childTask.append(subTask)
            try modelContext.save()
            dismiss()
        } catch {
            modelContext.rollback()
            validationMessage = "追加に失敗しました"
            isValidation = true
        }
        
        
    }
}
