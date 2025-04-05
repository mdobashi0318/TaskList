//
//  CloseButton.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/04/04.
//

import SwiftUI

struct CloseButton: View {
    
    var role: ButtonRole = .cancel
    
    var action: () -> Void
    
    var body: some View {
        Button(role: role, action: {
            action()
        }, label: {
            Image(systemName: "xmark")
        })
    }
}

