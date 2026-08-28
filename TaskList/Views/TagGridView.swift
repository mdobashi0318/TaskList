//
//  TagGridView.swift
//  TaskList
//
//  Created by 土橋正晴 on 2026/05/29.
//

import SwiftUI

struct TagGridView: View {
    
    private let columns = [GridItem(.flexible()),GridItem(.flexible())]
    let tags: [Tag]
    @Binding var tagSelect: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Button("tag") {
                tagSelect.toggle()
            }
            .foregroundStyle(Color.textColor)
            Spacer()
            LazyHGrid(rows: columns, alignment: .top) {
                ForEach(tags) { tag in
                    HStack {
                        ColorCircleView(color: tag.color())
                        Text(tag.name)
                            .lineLimit(1)
                    }
                }
            }
        }
    }
}
//
//#Preview {
//    TagGridView()
//}
