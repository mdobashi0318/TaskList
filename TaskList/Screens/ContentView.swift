//
//  ContentView.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/02/05.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var addTaskViewFlg: Bool = false
    
    @AppStorage(UserDefaults.Key.selectStatus.rawValue) private var selectStatus: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Picker(R.string.label.status(), selection: $selectStatus) {
                    Text("")
                        .tag("")
                    ForEach(TaskStatus.allCases) {
                        Text($0.title)
                            .tag($0.rawValue)
                    }
                }
                TaskListView(selectStatus: selectStatus)
            }
            .navigationTitle("TaskList")
            .navigationDestination(for: TaskModel.self) {
                TaskDetailScreen(model: $0)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    AddButton(action: {
                        addTaskViewFlg.toggle()
                    })
                }
            }
            .fullScreenCover(isPresented: $addTaskViewFlg) {
                AddTaskScreen()
            }
        }
        
    }
}

#Preview {
    ContentView()
}
