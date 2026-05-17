//
//  EditTagView.swift
//  TaskList
//
//  Created by 土橋正晴 on 2026/05/10.
//

import SwiftUI
import SwiftData

struct EditTagView: View {
    
    enum AlertType {
        case delete
        case common(String, String, (()->Void))
    }
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    /// 削除確認フラグ
    @State private var isDeleteConfilm = false
    /// タグの編集不可フラグ
    @State private var isEditDisabled = true
    @State private var name: String
    @State private var color: CGColor
    @State private var isShowAlert = false
    @State private var alertType: AlertType = .common("エラーが発生しました", "", {})
    @Bindable private var tag: Tag
    
    init(tag: Tag) {
        self.tag = tag
        name = tag.name
        color = tag.color()
    }
    
    var body: some View {
        TagView(name: $name, color: $color, disabledFlag: $isEditDisabled)
            .navigationTitle(isEditDisabled ? "タグ詳細" : "タグ編集")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    navigationBarTrailingButton()
                }
            }
            .alert(isPresented: $isShowAlert) {
                return switch alertType {
                case .delete:
                    Alert(title: Text("削除しますか？"), primaryButton: .destructive(Text("delete"), action: delete), secondaryButton: .cancel(Text("Cancel")))
                case .common(let title, let message, let action):
                    Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("閉じる"), action: action))
                }
            }
    }
    
    @ViewBuilder
    private func navigationBarTrailingButton() -> some View {
        if isEditDisabled {
            deleteButton
            editButton
        } else {
            cancelButton
            doneButton
        }
    }
    
    private var editButton: some View {
        Button(action: {
            isEditDisabled.toggle()
        }) {
            Text("編集")
        }
    }
    
    private var doneButton: some View {
        Button(action: {
            tag.update(name: name, color: color)
            try? modelContext.save()
            isEditDisabled.toggle()
        }) {
            Text("Done")
        }
    }
    
    private var deleteButton: some View {
        IconButton(action: {
            showAlert(.delete)
        }, iconName: .trash)
    }
    
    private func delete() {
        modelContext.delete(tag)
        try? modelContext.save()
        dismiss()
    }
    
    private var cancelButton: some View {
        Button(action: {
            isEditDisabled.toggle()
            modelContext.rollback()
            name = tag.name
            color = tag.color()
        }) {
            Text("キャンセル")
        }
    }
    
    private func showAlert(_ type: AlertType) {
        isShowAlert.toggle()
        alertType = type
    }
}


struct EditTagView_Previews: PreviewProvider {
    
    static func dummy() -> Tag {
        let tag = Tag()
        tag.name = "name"
        tag.blue = "10"
        tag.green = "10"
        tag.red = "10"
        tag.alpha = "10"
        
        return tag
    }
    
    static var previews: some View {
        EditTagView(tag: dummy())
    }
}


