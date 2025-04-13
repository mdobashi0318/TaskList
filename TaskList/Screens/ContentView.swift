//
//  ContentView.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/02/05.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query var taskList: [TaskModel]
    
    @State var addTaskViewFlg: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(taskList) { model in
                    NavigationLink(value: model) {
                        VStack {
                            Text(model.title)
                            Text("\(model.childTaskId.count) 個")
                        }
                    }
                }
            }
            .navigationTitle("TaskList")
            .navigationDestination(for: TaskModel.self) {
                TaskDetailScreen(model: $0)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        addTaskViewFlg.toggle()
                    }, label: {
                        Image(systemName: "plus")
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
