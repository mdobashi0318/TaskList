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
    
    let model: TaskModel
    
    var body: some View {
        HStack() {
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(Prioritys(rawValue: model.priority)?.color ?? .clear)
                .frame(width: 8)
                .padding([.leading, .top, .bottom], 3)
            VStack(alignment: .leading) {
                Text(model.title)
                HStack {
                    Text("ステータス: ")
                    Text("\(TaskStatus(rawValue: model.status)?.title ?? "")")
                        .foregroundStyle(TaskStatus(rawValue: model.status)?.color ?? .textColor)
                }
            }
            Spacer()
            if !model.childTask.isEmpty {
                VStack(alignment: .trailing) {
                    Text("サブタスク")
                    countLabel
                }
            }
        }
    }
    
    private var countLabel: some View {
        Label("\(model.childTask.count(where: { $0.status == TaskStatus.done.rawValue }))/\(model.childTask.count)", systemImage: checklistImage)
            .foregroundStyle(Color.textColor)
    }
    
    private var checklistImage: String {
        if model.childTask.count(where: { $0.status == TaskStatus.done.rawValue }) == model.childTask.count {
            "checklist.checked"
        } else if model.childTask.count(where: { $0.status == TaskStatus.done.rawValue }) > 0 {
            "checklist"
        } else {
            "checklist.unchecked"
        }
    }
    
}
