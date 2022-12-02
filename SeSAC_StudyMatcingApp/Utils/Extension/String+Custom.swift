//
//  String+Custom.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/08.
//

import Foundation

extension String {
    
    static let dateFormatter = DateFormatter()
    
    func validMessage(idx: Int) -> String? {
        guard (0..<count).contains(idx) else {
            return nil
        }
        
        let result = index(startIndex, offsetBy: idx)
        
        return String(self[...result])
    }
    
    func saveNumber() -> String {
        let saveText = self.components(separatedBy: [" ","-"]).joined()
        return saveText
    }
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.date(from: self)!
    }
}
