//
//  SubTaskDetailScreen.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/04/07.
//

import SwiftUI
import SwiftData

struct SubTaskDetailScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) var modelContext
    
    @State private var isSetStartDate = false
    
    @State private var isSetEndDate = false
    
    @State private var isValidation = false
    @State private var validationMessage = "未入力箇所があります。"
    
    @Bindable var subTask: SubTask
        
    @State private var backConfirmAlert: Bool = false
    
    
    var body: some View {
        List {
            Section(content: {
                TextField(R.string.message.inputTitle(), text: $subTask.title)
            }, header: {
                Text(R.string.label.title())
            })
            
            Section(content: {
                TextField(R.string.message.inputDetail(), text: $subTask.detail)
            }, header: {
                Text(R.string.label.detail())
            })
            
            Section(content: {
                Toggle(R.string.message.isSetStartDate(), isOn: $isSetStartDate)
                
                if isSetStartDate {
                    DatePicker(R.string.message.inputStartDate(), selection: $subTask.noSaveStartDate)
                }
                
                Toggle(R.string.message.isSetDeadline(), isOn: $isSetEndDate)
                
                if isSetEndDate {
                    DatePicker(R.string.message.inputDeadline(), selection: $subTask.noSaveDeadline)
                }
                
            }, header: {
                Text(R.string.label.date())
            })
            
            
            Section(content: {
                Picker(R.string.label.priority(), selection: $subTask.priority) {
                    ForEach(Prioritys.allCases) {
                        Text($0.title)
                            .tag($0)
                    }
                }
                
                Picker(R.string.label.status(), selection: $subTask.status) {
                    ForEach(TaskStatus.allCases) {
                        Text($0.title)
                            .tag($0)
                    }
                }
            })
            
            Section(content: {
                TextField("工数を入力してください", text: $subTask.noSaveManHours)
                    .keyboardType(.numbersAndPunctuation)
            }, header: {
                Text("工数")
            })
        }
        .navigationTitle("サブタスク")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    guard modelContext.hasChanges else {
                        dismiss()
                        return
                    }
                    backConfirmAlert = true
                }) {
                    Image(systemName: "chevron.backward")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    delete()
                }) {
                    Image(systemName: "trash")
                }
            }
            
        }
        .alert("変更されている箇所があります、保存して離れますか？", isPresented: $backConfirmAlert, actions: {
            saveButton
            notSavedBackButton
            Button(role: .cancel, action: {
                backConfirmAlert = false
            }, label: {
                Text("キャンセル")
            })
            
        })
        .alert(validationMessage, isPresented: $isValidation, actions: {
            Button(role: .cancel, action: {
                backConfirmAlert = false
            }, label: {
                Text(R.string.button.close())
            })
            
        })
        .task(id: subTask) {
            isSetStartDate = subTask.startDate != nil
            isSetEndDate = subTask.deadline != nil
        }
        .task(id: isSetStartDate) {
            if isSetStartDate {
                if subTask.startDate == nil {
                    subTask.startDate = DateFormatter.format_yyyyMMddHHmm()
                }
            } else {
                /// 最初からnilだった時に、変更扱いになってしまうので、nilじゃないときにnilを入れるようにする
                if subTask.startDate != nil {
                    subTask.startDate = nil
                }
            }
        }
        .task(id: isSetEndDate) {
            if isSetEndDate {
                if subTask.deadline == nil {
                    subTask.deadline = DateFormatter.format_yyyyMMddHHmm()
                }
            } else {
                /// 最初からnilだった時に、変更扱いになってしまうので、nilじゃないときにnilを入れるようにする
                if subTask.deadline != nil {
                    subTask.deadline = nil
                }
            }
            
        }
    }
    
    
    private var saveButton: some View {
        Button(role: .none, action: {
            do {
                if !subTask.isDoubleManHours {
                    validationMessage = "工数の値が不正です。"
                    isValidation = true
                    return
                }
                subTask.update(isSetStartDate: isSetStartDate, isSetEndDate: isSetEndDate)
                try modelContext.save()
                dismiss()
            } catch {
                modelContext.rollback()
                validationMessage = "更新に失敗しました"
                isValidation = true
            }
        }, label: {
            Text("保存")
        })
    }
    
    
    private var notSavedBackButton: some View {
        Button(role: .none, action: {
            backConfirmAlert = false
            modelContext.rollback()
            dismiss()
            
        }, label: {
            Text("変更箇所を戻して、前画面に戻る")
        })
    }
    
    private func delete() {
        do {
            modelContext.delete(subTask)
            try modelContext.save()
            dismiss()
        } catch {
            modelContext.rollback()
            validationMessage = "削除に失敗しました"
            isValidation = true
        }
    }
    
}
