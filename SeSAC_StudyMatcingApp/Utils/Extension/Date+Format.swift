//
//  Date+Format.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/12.
//

import Foundation

extension Date {
    static let formatter = DateFormatter()
    
    func datePickerFormat(dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    func dateStringFormat(date: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "UTC+18")
        formatter.dateFormat = date
        return formatter.string(from: self)
    }
    
    func nowDateFormat(date: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = date
        return formatter.string(from: self)
    }
}
