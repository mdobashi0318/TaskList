//
//  SelectTagScreen.swift
//  TaskList
//
//  Created by 土橋正晴 on 2026/05/21.
//

import SwiftUI
import SwiftData

struct SelectTagScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @Query private var tags: [Tag]
    @State private var isAddViewFlg = false
    @Binding var tag: Tag?
    
    var body: some View {
        NavigationStack {
            list
            .navigationTitle("SelectTagList")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    IconButton(action: {
                        dismiss()
                    }, iconName: .xmark)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    IconButton(action: {
                        dismiss()
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
        VStack {
            if tags.isEmpty {
                Button(action: {
                    isAddViewFlg.toggle()
                }) {
                    Text("タグの追加")
                }
            } else {
                List(selection: $tag) {
                    HStack {
                        Button(action: {
                            isAddViewFlg.toggle()
                        }) {
                            Text("タグの追加")
                        }
                        .buttonStyle(.plain)
                        Spacer()
                        Button(action: {
                            tag = nil
                        }) {
                            Text("deselect")
                        }
                        .buttonStyle(.plain)
                    }
                    ForEach(tags, id: \.self) { tag in
                        TagRow(tag: tag)
                    }
                }
                .environment(\.editMode, .constant(.active))
            }
        }
    }
}

//#Preview {
//    SelectTagScreen()
//}
