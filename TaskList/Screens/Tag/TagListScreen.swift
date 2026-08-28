//
//  TagListScreen.swift
//  TaskList
//
//  Created by 土橋正晴 on 2026/05/09.
//

import SwiftUI
import SwiftData

struct TagListScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @Query private var tags: [Tag]
    @State private var isAddViewFlg = false
    
    var body: some View {
        NavigationStack {
            list
            .navigationTitle("TagListScreen")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    IconButton(action: {
                        dismiss()
                    }, iconName: .xmark)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    IconButton(action: {
                        isAddViewFlg.toggle()
                    }, iconName: .plus)
                }
            }
            .sheet(isPresented: $isAddViewFlg) {
                AddTagView()
            }
        }
    }
    
    @ViewBuilder
    private var list: some View {
        if tags.isEmpty {
            Text("タグがまだありません")
        } else {
            List {
                ForEach(tags) { tag in
                    NavigationLink(value: tag) {
                        TagRow(tag: tag)
                    }
                }
            }
            .navigationDestination(for: Tag.self) {
                EditTagView(tag: $0)
            }
        }
    }
}

#Preview {
    TagListScreen()
}
