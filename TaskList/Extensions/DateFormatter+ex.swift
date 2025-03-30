//
//  DateFormatter+ex.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/03/29.
//

import Foundation

extension DateFormatter {
    
    static let created_at = format_yyyyMMddHHmmSSSS()
    
    
    // 現在日時をの文字列をyyy/MM/dd HH:mm:SSSS形式で返す
    static func format_yyyyMMddHHmmSSSS() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:SSSS"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.string(from: Date.now)
    }
        
}
