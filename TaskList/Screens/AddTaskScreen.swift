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

    
    @State private var startDate: Date = Date()
    @State private var startDateStr: String = ""
    
    @State private var endDate: Date = Date()
    @State private var endDateStr: String = ""
    
    @State private var priority: Prioritys = .none
    
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
                    DatePicker("開始日時を選択してください", selection: $startDate)
                    DatePicker("期日を選択してください", selection: $endDate)
                }, header: {
                    Text("日時")
                })
                
                
                Section(content: {
                    Picker("優先度を選択してください", selection: $priority) {
                        ForEach(Prioritys.allCases) {
                            Text($0.rawValue)
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
                
        }
    }
    
    
    private func addTask() {
        let taskModel = TaskModel()
        taskModel.add(id: UUID().uuidString,
                      title: title,
                      detail: detail,
                      priority: priority.rawValue,
                      tag: "")
        
        
        modelContext.insert(taskModel)
        dismiss()
    }
}
