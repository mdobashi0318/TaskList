//
//  SubTaskRow.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/04/13.
//

import SwiftUI
import SwiftData

struct SubTaskRow: View {
    
    @Bindable var subTask: SubTask
    
    @Environment(\.modelContext) var modelContext
    
    private let cornerRadius: CGFloat = 6
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(lineWidth: 1)
            .frame(width: 150, height: 100)
            .cornerRadius(cornerRadius)
            .tint(.secondary)
            .background(Color.systemBackground)
            .cornerRadius(cornerRadius)
            .clipped()
            .shadow(color: .secondary.opacity(0.2), radius: cornerRadius)
            .overlay(content: {
                VStack(alignment: .center) {
                    UnevenRoundedRectangle(topLeadingRadius: cornerRadius, topTrailingRadius: cornerRadius, style: .continuous)
                        .foregroundStyle(Prioritys(rawValue: subTask.priority)?.color ?? .clear)
                        .frame(height: 5)
                        .padding([.leading, .trailing, .top], 3)
                    Text(subTask.title)
                        .tint(Color.textColor)
                        .accessibility(identifier: "titlelabel")
                        .frame(alignment: .center)
                    Text(subTask.dispHour())
                        .tint(Color.textColor)
                        .frame(alignment: .center)
                    Spacer()
                    
                    Picker(R.string.label.status(), selection: $subTask.status) {
                        ForEach(TaskStatus.allCases) {
                            Text($0.title)
                                .tag($0)
                        }
                    }
                    .onChange(of: subTask.status) {
                        try? modelContext.save()
                    }
                    .tint(Color.textColor)
                    .background(Color.systemBackground)
                    .padding(.bottom, 5)
                }
            })
    }
}
