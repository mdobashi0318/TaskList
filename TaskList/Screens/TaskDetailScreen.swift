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
    
    @Bindable private var model: TaskModel
    
    @State private var isShowAlert: Bool = false
    @State private var alertMessage = ""
    
    @State private var isConfirmAlert = false
    
    @State private var isConfirmationDialog: Bool = false
    
    @State private var isShowEditSheet: Bool = false
    
    @State private var isShowAddSubTaskSheet: Bool = false
    
    @Query private var subTasks: [SubTask]
    
    var test = ""
    init(model: TaskModel) {
        self.model = model
        let modelId = model.id
        _subTasks = Query(filter: #Predicate<SubTask> { subTask in
            subTask.parentTaskId == modelId
        })
    }
        
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
            
            
            taskSection(title: "未実施", model.childTaskId, status: .notImplemented, shouldAddButton: true)
            taskSection(title: "実施中", model.childTaskId, status: .inProcess)
            taskSection(title: "保留", model.childTaskId, status: .pending)
            taskSection(title: "完了", model.childTaskId, status: .done)
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
                Text("閉じる")
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
    }
    
    private func taskSection(title: String, _ taskModel: [String], status: TaskStatus, shouldAddButton: Bool = false) -> some View {
        let dispModel = subTasks.filter({
            $0.status == status.rawValue
        })
        return Section(content: {
            ScrollView(.horizontal) {
                Grid {
                    GridRow {
                        ForEach(dispModel, id: \.id) { child in
                            NavigationLink(value: child) {
                                
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
            }
        }, header: {
            HStack {
                Text(title)
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
