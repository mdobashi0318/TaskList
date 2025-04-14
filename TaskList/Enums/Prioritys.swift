//
//  Prioritys.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/03/26.
//

import Foundation
import SwiftUI

enum Prioritys: String, CaseIterable, Identifiable {
    case none = "0"
    case low = "1"
    case medium = "2"
    case high = "3"
    
    
    var id: String { self.rawValue }
    
    
    var title: String {
        switch self {
        case .low:
            "低"
        case .medium:
            "中"
        case .high:
            "高"
        case .none:
            ""
        }
    }
    
    
    var color: Color {
        switch self {
        case .low:
                .blue
        case .medium:
                .yellow
        case .high:
                .red
        case .none:
                .clear
        }
    }
}
