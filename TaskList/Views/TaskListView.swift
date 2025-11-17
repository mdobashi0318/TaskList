//
//  TaskListView.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/04/19.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query var taskList: [TaskModel]
    
    init(selectStatus: String) {
        _taskList = Query(filter: #Predicate { model in
            if selectStatus.isEmpty {
                true
            } else {
                model.status.localizedStandardContains(selectStatus)
            }
        }, sort: [SortDescriptor(\TaskModel.priority, order: .reverse), SortDescriptor(\TaskModel.status)])}
    
    
    var body: some View {
        if taskList.isEmpty {
            Text("NoTaskList")
        } else {
            ForEach(taskList) { model in
                NavigationLink(value: model) {
                    TaskRow(model: model)
                }
            }
        }
    }
}
