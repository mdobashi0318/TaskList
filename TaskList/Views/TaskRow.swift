//
//  TaskRow.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/04/16.
//

import SwiftUI
import SwiftData

struct TaskRow: View {
    
    @Environment(\.modelContext) private var modelContext
    
    private let model: TaskModel
    
    @Query private var subTasks: [SubTask]
    
    init(model: TaskModel) {
        self.model = model
        let modelId = model.id
        _subTasks = Query(filter: #Predicate<SubTask> { subTask in
            subTask.parentTaskId == modelId
        })
    }
    
    var body: some View {
        HStack() {
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(TaskStatus(rawValue: model.status)?.color ?? .clear)
                .frame(width: 8)
                .padding([.leading, .top, .bottom], 3)
            VStack(alignment: .leading) {
                Text(model.title)
                Text("ステータス: \(TaskStatus(rawValue: model.status)?.title ?? "")")
            }
            Spacer()
            VStack {
                ForEach(TaskStatus.allCases) { status in
                    HStack {
                        Spacer()
                        Text(status.title)
                        Text(": \(subTasks.count(where: { $0.status == status.rawValue}))")
                    }
                    
                }
            }
        }
    }
    
}
