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
                Text("ステータス: \(TaskStatus(rawValue: model.status)?.title ?? "")")
            }
            Spacer()
            if !model.childTask.isEmpty {
                VStack(alignment: .trailing) {
                    Text("サブタスク")
                    ForEach(TaskStatus.allCases) { status in
                        HStack {
                            Spacer()
                            Text(status.title)
                            Text(": \(model.childTask.count(where: { $0.status == status.rawValue}))")
                        }
                        
                    }
                }
            }
        }
    }
    
}
