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
    
    @Attribute(.unique) var id: String = ""
    
    var title: String = ""
    /// 詳細
    var detail: String = ""
    /// 親タスク
    var parentTask: TaskModel?
    /// 開始日
    var startDate: String?
    /// 期限
    var deadline: String?
    /// 優先度
    var priority: String = Prioritys.none.rawValue
    /// 実施状況
    var status: String = TaskStatus.notImplemented.rawValue
    /// タグ
    var tag: String?
    
    var manHours: String = ""
    
    var created_at: String = ""
    
    var updated_at: String = ""

    init() { }
    
    init(id: String, title: String, detail: String, parentTask: TaskModel, startDate: String? = nil, status: String) {
        self.id = id
        self.title = title
        self.detail = detail
        self.parentTask = parentTask
        self.startDate = startDate
        self.status = status
    }
    
    func add(title: String, detail: String, parentTask: TaskModel, startDate: String?, deadline: String?, priority: String) {
        let created_at = DateFormatter.created_at
        
        self.id = UUID().uuidString
        self.title = title
        self.detail = detail
        self.parentTask = parentTask
        self.startDate = startDate
        self.deadline = deadline
        self.priority = priority
        self.status = TaskStatus.notImplemented.rawValue
        self.created_at = created_at
        self.updated_at = created_at
    }
    
    
    func update(isSetStartDate: Bool, isSetEndDate: Bool, title: String, detail: String, startDate: Date?, deadline: Date?, priority: String, status: String, manHours: String) {
        if isSetStartDate {
            self.startDate = DateFormatter.format_yyyyMMddHHmm(startDate ?? Date.now)
        } else {
            self.startDate = nil
        }
        
        if isSetEndDate {
            self.deadline = DateFormatter.format_yyyyMMddHHmm(deadline ?? Date.now)
        } else {
            self.deadline = nil
        }
        self.title = title
        self.detail = detail
        self.priority = priority
        self.status = status
        self.manHours = "\(floor((Double(manHours) ?? 0) * 100)/100)"
        self.updated_at = DateFormatter.created_at
    }
    
    func dispHour() -> String {
        "\(floor((Double(manHours) ?? 0) * 100)/100)"
    }
    
    func hasChanges(title: String, detail: String, startDate: String?, deadline: String?, priority: String, status: String, manHours: String, isSetStartDate: Bool, isSetEndDate: Bool) -> Bool {
        let startDate = isSetStartDate ? startDate : nil
        let deadline = isSetEndDate ? deadline : nil
        
        if self.title == title &&
            self.detail == detail &&
            self.startDate == startDate &&
            self.deadline == deadline &&
            self.priority == priority &&
            self.status == status &&
            self.manHours == manHours {
            return false
        } else {
            return true
        }
    }
    
}

