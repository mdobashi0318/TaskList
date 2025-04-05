//
//  TaskModel.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/03/09.
//

import Foundation
import SwiftData

@Model
class TaskModel {
    
    @Attribute(.unique) var id: String = ""
    
    var title: String = ""
    /// 詳細
    var detail: String = ""
    /// 小タスク
    var childTaskId: [String] = []
    /// 開始日
    var startDate: String?
    /// 期限
    var deadline: String?
    /// 優先度
    var priority: String = Prioritys.none.rawValue
    /// 状態
    var status: String = TaskStatus.notImplemented.rawValue
    /// タグ
    var tag: String?
    
    var created_at: String = ""
    
    var updated_at: String = ""
    
    init() {}
    
    init(id: String, title: String, detail: String, childTaskId: [String], startDate: String? = nil, deadline: String? = nil, priority: String, status: String, tag: String? = nil, created_at: String, updated_at: String) {
        self.id = id
        self.title = title
        self.detail = detail
        self.childTaskId = childTaskId
        self.startDate = startDate
        self.deadline = deadline
        self.priority = priority
        self.status = status
        self.tag = tag
        self.created_at = created_at
        self.updated_at = updated_at
    }
    
    
    func add(title: String, detail: String, startDate: String?, deadline: String?, priority: String, tag: String? = nil) {
        let created_at = DateFormatter.created_at
        
        self.id = UUID().uuidString
        self.title = title
        self.detail = detail
        self.childTaskId = []
        self.startDate = startDate
        self.deadline = deadline
        self.priority = priority
        self.status = TaskStatus.notImplemented.rawValue
        self.tag = tag
        self.created_at = created_at
        self.updated_at = created_at
    }
 
    
    func update(startDate: String?, deadline: String?, tag: String? = nil) {
        self.childTaskId = []
        self.startDate = startDate
        self.deadline = deadline
        self.status = TaskStatus.notImplemented.rawValue
        self.tag = tag
        self.updated_at = DateFormatter.created_at
    }
    
}
