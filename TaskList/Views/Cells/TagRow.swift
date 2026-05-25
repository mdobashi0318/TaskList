//
//  TagRow.swift
//  TaskList
//
//  Created by 土橋正晴 on 2026/05/11.
//

import SwiftUI

struct TagRow: View {
    
    let tag: Tag
    
    var body: some View {
        HStack {
            ColorCircleView(color: tag.color())
            Text(tag.name)
            
        }
    }
}

//#Preview {
//    TagRow()
//}
