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
    
    @Transient
    var noSaveManHours: String {
        get {
            manHours
        } set {
            manHours = "\(floor((Double(newValue) ?? 0) * 100)/100)"
        }
    }
    
    @Transient
    var isDoubleManHours: Bool {
        if manHours.isEmpty {
            return true
        }
        guard let _ = Double(manHours) else {
            return false
        }
        return true
    }
    
    
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
    
    func dispHour() -> String {
        "\(floor((Double(manHours) ?? 0) * 100)/100)"
    }
    
}

