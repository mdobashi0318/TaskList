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
    @Relationship(deleteRule: .cascade, inverse: \SubTask.parentTask)
    var childTask: [SubTask] = []
    /// 開始日
    var startDate: String?
    /// 期限
    var deadline: String?
    /// 優先度
    var priority: String = Prioritys.none.rawValue
    /// 状態
    var status: String = TaskStatus.notImplemented.rawValue
    
    var created_at: String = ""
    
    var updated_at: String = ""
    
    
    @Transient
    var noSaveStartDate: Date {
        get {
            DateFormatter.format_yyyyMMddHHmm_str(startDate ?? "")
        } set {
            startDate = DateFormatter.format_yyyyMMddHHmm(newValue)
        }
    }
    
    
    @Transient
    var noSaveDeadline: Date {
        get {
            DateFormatter.format_yyyyMMddHHmm_str(deadline ?? "")
        } set {
            deadline = DateFormatter.format_yyyyMMddHHmm(newValue)
        }
    }
    
    init() {}
    
    init(id: String, title: String, detail: String, childTask: [SubTask], startDate: String? = nil, deadline: String? = nil, priority: String, status: String, created_at: String, updated_at: String) {
        self.id = id
        self.title = title
        self.detail = detail
        self.childTask = childTask
        self.startDate = startDate
        self.deadline = deadline
        self.priority = priority
        self.status = status
        self.created_at = created_at
        self.updated_at = updated_at
    }
    
    
    func add(title: String, detail: String, startDate: String?, deadline: String?, priority: String) {
        let created_at = DateFormatter.created_at
        
        self.id = UUID().uuidString
        self.title = title
        self.detail = detail
        self.childTask = []
        self.startDate = startDate
        self.deadline = deadline
        self.priority = priority
        self.status = TaskStatus.notImplemented.rawValue
        self.created_at = created_at
        self.updated_at = created_at
    }
    
    
    func update(isSetStartDate: Bool, isSetEndDate: Bool) {
        if isSetStartDate {
            if startDate == nil {
                startDate = DateFormatter.format_yyyyMMddHHmm()
            }
        } else {
            startDate = nil
        }
        
        if isSetEndDate {
            if deadline == nil {
                deadline = DateFormatter.format_yyyyMMddHHmm()
            }
        } else {
            deadline = nil
        }
        
        self.updated_at = DateFormatter.created_at
    }
    
}
