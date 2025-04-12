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
                TextField("タイトルを入力してください", text: $subTask.title)
            }, header: {
                Text("タイトル")
            })
            
            Section(content: {
                TextField("詳細を入力してください", text: $subTask.detail)
            }, header: {
                Text("詳細")
            })
            
            Section(content: {
                Toggle("開始日時をセットする", isOn: $isSetStartDate)
                
                if isSetStartDate {
                    DatePicker("開始日時を選択してください", selection: $subTask.noSaveStartDate)
                }
                
                Toggle("期日をセットする", isOn: $isSetEndDate)
                
                if isSetEndDate {
                    DatePicker("期日を選択してください", selection: $subTask.noSaveDeadline)
                }
                
            }, header: {
                Text("日時")
            })
            
            
            Section(content: {
                Picker("優先順位", selection: $subTask.priority) {
                    ForEach(Prioritys.allCases) {
                        Text($0.title)
                            .tag($0)
                    }
                }
            }, header: {
                Text("日時")
            })
        }
        .navigationTitle("サブタスク詳細")
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
        .task(id: subTask) {
            isSetStartDate = subTask.startDate != nil
            isSetEndDate = subTask.deadline != nil
        }
    }
    
    
    private var saveButton: some View {
        Button(role: .none, action: {
            do {
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
}
