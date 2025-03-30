//
//  Prioritys.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/03/26.
//

import Foundation

enum Prioritys: String, CaseIterable, Identifiable {
    case none = "0"
    case low = "1"
    case normal = "2"
    case high = "3"
    
    
    var id: String { self.rawValue }
}
