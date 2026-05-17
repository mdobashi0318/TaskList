//
//  Tag.swift
//  TaskList
//
//  Created by 土橋正晴 on 2026/05/09.
//

import Foundation
import SwiftData
import UIKit

@Model
class Tag {
    @Attribute(.unique) var id: String = ""
    var name: String = ""
    var red: String = ""
    var green: String = ""
    var blue: String = ""
    var alpha: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    
    init() { }
    
    func add(name: String, color: CGColor) {
        let now = DateFormatter.created_at
        
        self.id = UUID().uuidString
        self.name = name
        self.red = color.components?[0].description ?? "0"
        self.green = color.components?[1].description ?? "0"
        self.blue = color.components?[2].description ?? "0"
        self.alpha = color.components?[3].description ?? "0"
        self.created_at = now
        self.updated_at = now
    }
    
    func update(name: String, color: CGColor) {
        self.name = name
        self.red = color.components?[0].description ?? "0"
        self.green = color.components?[1].description ?? "0"
        self.blue = color.components?[2].description ?? "0"
        self.alpha = color.components?[3].description ?? "0"
        self.updated_at = DateFormatter.created_at
    }
    
    func color() -> CGColor  {
        return CGColor(red: CGFloat(truncating:NumberFormatter().number(from: red) ?? 0.0),
                       green: CGFloat(truncating:NumberFormatter().number(from: green) ?? 0.0),
                       blue: CGFloat(truncating:NumberFormatter().number(from: blue) ?? 0.0),
                       alpha: CGFloat(truncating:NumberFormatter().number(from: alpha) ?? 0.0)
        )
    }
}
