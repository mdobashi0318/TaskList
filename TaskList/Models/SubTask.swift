//
//  SubTask.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/03/23.
//

import Foundation
import SwiftData


@Model
class SubTask {
    
    var id: String
    
    var title: String
    /// 詳細
    var detail: String
    /// 親タスク
    var parentTaskId: String
    /// 開始日
    var startDate: Date?
    /// 実施状況
    var status: String = TaskStatus.notImplemented.rawValue
    
    
    
    init (id: String, title: String, detail: String, parentTaskId: String, startDate: Date? = nil, status: String) {
        self.id = id
        self.title = title
        self.detail = detail
        self.parentTaskId = parentTaskId
        self.startDate = startDate
        self.status = status
    }
    
}

