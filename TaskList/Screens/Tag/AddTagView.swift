//
//  AddTagView.swift
//  TaskList
//
//  Created by 土橋正晴 on 2026/05/10.
//

import SwiftUI

struct AddTagView: View {
    
    @State var color: CGColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    @State var name: String = ""
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    /// Alertの表示フラグ
    @State private var isShowAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            TagView(name: $name, color: $color, disabledFlag: .constant(false))
                .navigationTitle("タグ追加")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        addButton
                    }
                }
                .alert(isPresented: $isShowAlert) {
                    return Alert(title: Text(errorMessage), dismissButton: .default(Text("閉じる")))
                }
        }
    }
    
    private var addButton: some View {
        IconButton(action: {
            guard !name.isEmpty else { return }
            let tag = Tag()
            tag.add(name: name, color: color)
            modelContext.insert(tag)
            try? modelContext.save()
            dismiss()
        }, iconName: .plus)
    }
    
}

struct InputTagView_Previews: PreviewProvider {
    static var previews: some View {
        AddTagView()
    }
}
