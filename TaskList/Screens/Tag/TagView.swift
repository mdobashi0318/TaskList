//
//  TagView.swift
//  TaskList
//
//  Created by 土橋正晴 on 2026/05/10.
//

import SwiftUI

struct TagView: View {
    
    @Binding var name: String
    @Binding var color: CGColor
    @Binding var disabledFlag: Bool
    
    var body: some View {
        Form {
            Section("タグ") {
                TextField("タグ名", text: $name)
                    .disabled(disabledFlag)
                ColorPicker("タグカラー", selection: $color)
                    .disabled(disabledFlag)
            }
        }
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(name: .constant("name"), color: .constant(.init(red: 10, green: 10, blue: 10, alpha: 1)), disabledFlag: .constant(false))
    }
}
