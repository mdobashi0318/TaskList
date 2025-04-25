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
    
    @State private var isConfirmationDialog: Bool = false
    
    @State private var isShowEditSheet: Bool = false
    
    @State private var isShowAddSubTaskSheet: Bool = false
        
    var body: some View {
        List {
            Section(content: {
                Text(model.title)
            }, header: {
                Text(R.string.label.title())
            })
            
            Section(content: {
                Text(model.detail)
            }, header: {
                Text(R.string.label.detail())
            })
            
            dateSection
            pickerSection
            
            subTaskSection(model.childTask, status: .notImplemented, shouldAddButton: true)
            subTaskSection(model.childTask, status: .inProcess)
            subTaskSection(model.childTask, status: .pending)
            subTaskSection(model.childTask, status: .done)
        }
        .navigationTitle("Task詳細")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EllipsisButton(action: {
                    isConfirmationDialog.toggle()
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
                Text(R.string.button.close())
            })
        })
        .confirmationDialog("このタスクをどうしますか？", isPresented: $isConfirmationDialog, actions: {
            Button(role: .none, action: {
                isShowEditSheet.toggle()
            },label: {
                Text("編集")
            })
            Button(role: .destructive, action: {
                isConfirmAlert.toggle()
            },label: {
                Text("削除")
            })
            Button(role: .cancel, action: {
                isConfirmationDialog = false
            }, label: {
                Text("キャンセル")
            })
        })
        .navigationDestination(for: SubTask.self) {
            SubTaskDetailScreen(subTask: $0)
        }
        .fullScreenCover(isPresented: $isShowEditSheet) {
            EditTaskScreen(model: model)
        }
        .fullScreenCover(isPresented: $isShowAddSubTaskSheet) {
            AddSubTaskScreen(taskModel: model)
        }
        .task(id: model.status) {
            try? modelContext.save()
        }
        .task(id: model.priority) {
            try? modelContext.save()
        }
    }
    
    
    private var dateSection: some View {
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
            Text(R.string.label.date())
        })
    }
    
    private var pickerSection: some View {
        Section {
            Picker(R.string.label.status(), selection: $model.status) {
                ForEach(TaskStatus.allCases) {
                    Text($0.title)
                        .tag($0.rawValue)
                }
            }
            
            Picker(R.string.label.priority(), selection: $model.priority) {
                ForEach(Prioritys.allCases) {
                    Text($0.title)
                        .tag($0.rawValue)
                }
            }
        }
    }
    
    private func subTaskSection(_ taskModel: [SubTask], status: TaskStatus, shouldAddButton: Bool = false) -> some View {
        let dispModel = model.childTask.filter({
            $0.status == status.rawValue
        })
        return Section(content: {
            ScrollView(.horizontal) {
                Grid {
                    GridRow {
                        ForEach(dispModel, id: \.id) { child in
                            NavigationLink(value: child) {
                                SubTaskRow(subTask: child)
                            }
                        }
                    }
                }
            }
        }, header: {
            HStack {
                Text(status.title)
                if shouldAddButton {
                    Spacer()
                    AddButton(action: {
                        isShowAddSubTaskSheet.toggle()
                    })
                }
            }
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
