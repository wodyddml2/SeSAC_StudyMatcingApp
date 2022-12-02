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
//        let formatter = DateFormatter()
        Date.formatter.dateFormat = dateFormat
        Date.formatter.locale = Locale(identifier: "ko_KR")
        return Date.formatter.string(from: self)
    }
    
    func dateStringFormat(date: String) -> String {
//        let formatter = DateFormatter()
        Date.formatter.locale = Locale(identifier: "ko_KR")
        Date.formatter.timeZone = TimeZone(identifier: "UTC+18")
        Date.formatter.dateFormat = date
        return Date.formatter.string(from: self)
    }
    
    func nowDateFormat(date: String) -> String {
//        let formatter = DateFormatter()
        Date.formatter.locale = Locale(identifier: "ko_KR")
        Date.formatter.timeZone = TimeZone(abbreviation: "KST")
        Date.formatter.dateFormat = date
        return Date.formatter.string(from: self)
    }
}
