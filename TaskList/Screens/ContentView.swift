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
    
    @AppStorage(UserDefaults.Key.addFirstTask.rawValue) private var addFirstTask: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                if addFirstTask {
                    pickerArea
                    TaskListView(selectStatus: selectStatus)
                } else {
                    Text("AddNoTask")
                }
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
    
    private var pickerArea: some View {
        Picker(R.string.label.status(), selection: $selectStatus) {
            Text("")
                .tag("")
            ForEach(TaskStatus.allCases) {
                Text($0.title)
                    .tag($0.rawValue)
            }
        }
    }
}

#Preview {
    ContentView()
}
