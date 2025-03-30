//
//  TaskDetailScreen.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/03/17.
//

import Foundation
import SwiftUI

struct TaskDetailScreen: View {
    
    var model: TaskModel
    
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
            
            taskSection(title: "未実施", model.childTaskId, status: .notImplemented)
            taskSection(title: "実施中", model.childTaskId, status: .inProcess)
            taskSection(title: "完了", model.childTaskId, status: .done)
        }
        .navigationTitle("Task詳細")
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
    
}
