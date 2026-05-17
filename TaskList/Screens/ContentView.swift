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
    /// タスク追加画面の表示フラグ
    @State private var addTaskViewFlg: Bool = false
    /// タグ一覧画面の表示フラグ
    @State private var tagListViewFlg: Bool = false
    /// 表示ステータスの保持
    @AppStorage(UserDefaults.Key.selectStatus.rawValue) private var selectStatus: String = ""
    /// タスクを作ったことがあるか保持
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
                ToolbarItemGroup(placement: .topBarTrailing) {
                    IconButton(action: {
                        tagListViewFlg.toggle()
                    }, iconName: .tag)
                    
                    IconButton(action: {
                        addTaskViewFlg.toggle()
                    }, iconName: .plus)
                }
            }
            .fullScreenCover(isPresented: $addTaskViewFlg) {
                AddTaskScreen()
            }
            .fullScreenCover(isPresented: $tagListViewFlg) {
                TagListScreen()
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
