//
//  TaskStatus.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/03/26.
//

import Foundation

enum TaskStatus: String, CaseIterable, Identifiable {
    /// 未実施
    case notImplemented = "0"
    /// 実施中
    case inProcess = "1"
    /// 完了
    case done = "2"
    /// 中止
    case pending = "3"
    
    
    var id: String { self.rawValue }
    
    
    var title: String {
        switch self {
        case .notImplemented:
            "未実施"
        case .inProcess:
            "実施中"
        case .done:
            "完了"
        case .pending:
            "保留"
        }
    }
}
