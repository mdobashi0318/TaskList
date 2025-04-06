//
//  TaskListApp.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/02/05.
//

import SwiftUI
import SwiftData

@main
struct TaskListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [TaskModel.self, SubTask.self])
        }
    }
}
