//
//  SubTaskDetailScreen.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/04/07.
//

import SwiftUI
import SwiftData

struct SubTaskDetailScreen: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Bindable var subTask: SubTask
    
    var body: some View {
        Text(subTask.title)
    }
}
