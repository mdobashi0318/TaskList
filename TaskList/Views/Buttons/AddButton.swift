//
//  AddButton.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/04/04.
//

import SwiftUI

struct AddButton: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: "plus")
        })
    }
}

