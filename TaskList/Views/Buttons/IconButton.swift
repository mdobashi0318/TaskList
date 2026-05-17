//
//  IconButton.swift
//  TaskList
//
//  Created by 土橋正晴 on 2026/05/09.
//

import SwiftUI

struct IconButton: View {
    
    var action: () -> Void
    
    var iconName: IconName
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: iconName.name)
        }
    }
    
    enum IconName {
        case plus
        case trash
        case ellipsis
        case xmark
        case tag
        case other(name: String)
        
        var name: String {
            switch self {
            case .plus:
                return "plus"
            case .trash:
                return "trash"
            case .ellipsis:
                return "ellipsis"
            case .xmark:
                return "xmark"
            case .tag:
                return "tag"
            case .other(let name):
                return name
            }
        }
    }
}

//#Preview {
//    IconButton()
//}
