//
//  DateFormatter.swift
//  CollectionViewDiffablePractice
//
//  Created by Joy Kim on 7/20/24.
//

import Foundation

class DateFormatterManager {
    
    static let shared = DateFormatterManager()
    private init() {}
    
    static func dateToString(date:String) -> String {
        
        let inputFormat = DateFormatter()
        inputFormat.dateFormat = "yyyy-MM-dd HH:mm"
        
        let outputFormat = DateFormatter()
        outputFormat.dateFormat = "yyyy.MM.dd"
        
        if let date = inputFormat.date(from: date) {
            return outputFormat.string(from: date)
        } else {
            return ""
        }
    }
}
