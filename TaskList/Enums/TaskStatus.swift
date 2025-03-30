//
//  TaskStatus.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/03/26.
//

import Foundation

enum TaskStatus: String, CaseIterable {
    /// 未実施
    case notImplemented = "0"
    /// 実施中
    case inProcess = "1"
    /// 完了
    case done = "2"
    /// 中止
    case suspension = "3"
}
