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
    
    @State private var isShowSubTask: Bool = false
    
    var body: some View {
        List {
            HStack {
                Text(R.string.label.title())
                Spacer()
                Text(model.title)
            }
            
            HStack {
                Text(R.string.label.detail())
                Spacer()
                Text(model.detail)
            }
            dateRow
            pickerSection
            Section(content: {
                Text("\(hours())")
            }, header: {
                Text("工数")
            })
            subTaskSection
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
        .navigationDestination(for: SubTask.self) { subTask in
            SubTaskDetailScreen(subTask: subTask)
                .onChange(of: subTask.status, initial: false, { onChangeSubTaskStatus(subTask) })
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
    
    
    @ViewBuilder
    private var dateRow: some View {
        let startDate =  model.startDate ?? ""
        let deadline = model.deadline ?? ""
        
        if startDate.isEmpty && deadline.isEmpty {
            EmptyView()
        } else {
            if !startDate.isEmpty {
                HStack {
                    Text("開始日時")
                    Spacer()
                    Text(startDate)
                }
            }
            
            if !deadline.isEmpty {
                HStack {
                    Text("期日")
                    Spacer()
                    Text(deadline)
                }
            }
        }
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
    
    @ViewBuilder
    private func subTaskRow(_ taskModel: [SubTask], status: TaskStatus) -> some View {
        let dispModel = model.childTask.filter({
            $0.status == status.rawValue
        })
        
        ScrollView(.horizontal) {
            Grid(alignment: .leading) {
                Text("\(status.title)(\(dispModel.count))")
                    .font(.caption)
                GridRow {
                    ForEach(dispModel, id: \.id) { child in
                        NavigationLink(value: child) {
                            SubTaskRow(subTask: child)
                                .onChange(of: child.status, initial: false, { onChangeSubTaskStatus(child) })
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var subTaskSection: some View {
        Section(content: {
            if isShowSubTask {
                subTaskRow(model.childTask, status: .notImplemented)
                subTaskRow(model.childTask, status: .inProcess)
                subTaskRow(model.childTask, status: .pending)
                subTaskRow(model.childTask, status: .done)
            }
        }, header: {
            HStack {
                Text("サブタスク")
                if !isShowSubTask {
                    subTaskCountHeader
                }
                
                Spacer()
                AddButton(action: {
                    isShowAddSubTaskSheet.toggle()
                })
                Button(action: {
                    isShowSubTask.toggle()
                }, label: {
                    isShowSubTask ? Image(systemName: "chevron.down") : Image(systemName: "chevron.up")
                })
            }
            
        })
    }
    
    @ViewBuilder
    private var subTaskCountHeader: some View {
        if  model.childTask.filter({ $0.status != TaskStatus.done.rawValue }).count > 0 {
            VStack {
                subTaskHeaderText(.notImplemented)
                subTaskHeaderText(.inProcess)
            }
            VStack {
                subTaskHeaderText(.pending)
                subTaskHeaderText(.done)
            }
            
        } else {
            Text("0件")
        }
    }
    
    private func subTaskHeaderText(_ status: TaskStatus) -> some View {
        Text("\(status.title):\(model.childTask.filter({ $0.status == status.rawValue }).count)")
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
    
    private func onChangeSubTaskStatus(_ subTask: SubTask) {
        if subTask.status == TaskStatus.inProcess.rawValue {
            model.status = TaskStatus.inProcess.rawValue
        }
    }
    
    
    private func hours() -> String {
        var hour: Double = 0.0
        model.childTask.forEach {
            hour += Double($0.manHours) ?? 0
        }
        return "\(floor(hour * 100)/100)"
    }
}
