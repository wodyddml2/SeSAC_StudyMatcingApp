//
//  Date+Format.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/12.
//

import Foundation

extension Date {
    func datePickerFormat(dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
