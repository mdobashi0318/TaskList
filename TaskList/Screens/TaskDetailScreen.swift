//
//  TaskDetailScreen.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/03/17.
//

import SwiftUI
import SwiftData

struct TaskDetailScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) var modelContext
    
    @Bindable var model: TaskModel
    
    @State private var isShowAlert: Bool = false
    @State private var alertMessage = ""
    
    @State private var isConfirmAlert = false
    
    var body: some View {
        List {
            Section(content: {
                Text(model.title)
            }, header: {
                Text("タイトル")
            })
            
            Section(content: {
                Text(model.detail)
            }, header: {
                Text("詳細")
            })
            
            Section(content: {
                VStack {
                    HStack {
                        Text("開始日時: ")
                        Spacer()
                        Text(model.startDate ?? "")
                    }
                    Divider()
                    HStack {
                        Text("期日: ")
                        Spacer()
                        Text(model.deadline ?? "")
                    }
                }
            }, header: {
                Text("日時")
            })
            
            
            if model.priority != Prioritys.none.rawValue {
                Section(content: {
                    Text(Prioritys(rawValue: model.priority)?.title ?? Prioritys.none.title)
                }, header: {
                    Text("優先順位")
                })
            }
            
            
            taskSection(title: "未実施", model.childTaskId, status: .notImplemented)
            taskSection(title: "実施中", model.childTaskId, status: .inProcess)
            taskSection(title: "完了", model.childTaskId, status: .done)
        }
        .navigationTitle("Task詳細")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isConfirmAlert.toggle()
                }, label: {
                    Image(systemName: "trash")
                })
            }
        }
        .alert("削除しますか?", isPresented: $isConfirmAlert, actions: {
            Button(role: .cancel, action: {
                isConfirmAlert.toggle()
            }, label: {
                Text("キャンセル")
            })
            
            Button(role: .destructive, action: {
                deleteTask()
            }, label: {
                Text("削除")
            })
        })
        .alert(alertMessage, isPresented: $isShowAlert, actions: {
            Button(role: .cancel, action: {
                isShowAlert.toggle()
            }, label: {
                Text("閉じる")
            })
        })
    }
    
    private func taskSection(title: String, _ taskModel: [String], status: TaskStatus) -> some View {
        let dispModel = [SubTask]()
        return Section(content: {
            ScrollView(.horizontal) {
                Grid {
                    GridRow {
                        ForEach(dispModel, id: \.id) { child in
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 1)
                                .foregroundStyle(.secondary)
                                .background(Color.clear)
                                .frame(width: 100, height: 50)
                                .overlay  {
                                    Text(child.title)
                                }
                        }
                    }
                }
            }
        }, header: {
            Text(title)
        })
    }
    
    
    private func deleteTask() {
        do {
            modelContext.delete(model)
            try modelContext.save()
            dismiss()
        } catch {
            alertMessage = "削除に失敗しました。"
            isShowAlert = true
            print("削除に失敗しました。 error: \(error)")
        }
        
    }
}
