//
//  ColorCircleView.swift
//  TaskList
//
//  Created by 土橋正晴 on 2026/05/25.
//

import SwiftUI

struct ColorCircleView: View {
    
    let color: CGColor
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.secondary, lineWidth: 2)
                .foregroundColor(Color.clear)
                .frame(width: 20, height: 20)
            Circle()
                .foregroundColor(Color(cgColor: color))
                .frame(width: 20, height: 20)
        }
    }
}
