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
    @State private var isShowAlert: Bool = false
    @Binding var tag: [Tag]
    private let maxTagCount: Int = 3
    
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
                        }, iconName: .other(name: "square.and.arrow.down"))
                    }
                }
                .sheet(isPresented: $isAddViewFlg) {
                    AddTagView()
                }
                .alert(isPresented: $isShowAlert) {
                    Alert(title: Text("選択できるのは\(maxTagCount)つまでです。"))
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
                List {
                    HStack {
                        Button(action: {
                            isAddViewFlg.toggle()
                        }) {
                            Text("タグの追加")
                        }
                        .buttonStyle(.plain)
                        Spacer()
                        Button(action: {
                            tag = []
                        }) {
                            Text("deselect")
                        }
                        .buttonStyle(.plain)
                    }
                    ForEach(tags, id: \.self) { item in
                        HStack {
                            TagRow(tag: item)
                            Spacer()
                            if isSelected(item) {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.tint)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggleSelection(item)
                        }
                    }
                }
            }
        }
    }
    
    private func isSelected(_ item: Tag) -> Bool {
        tag.contains(where: { $0 == item })
    }
    
    private func toggleSelection(_ item: Tag) {
        if let index = tag.firstIndex(where: { $0 == item }) {
            tag.remove(at: index)
        } else {
            guard maxTagCount > tag.count else {
                isShowAlert.toggle()
                return
            }
            tag.append(item)
        }
    }
}

//#Preview {
//    SelectTagScreen()
//}
