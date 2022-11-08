//
//  String+Custom.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/08.
//

import Foundation

extension String {

//    func validPhone(idx: Int) -> String? {
//        guard (0..<count).contains(idx) else {
//            return nil
//        }
//        
//        let result = index(startIndex, offsetBy: idx)
//        
//        return String(self[result])
//        
//    }
    
    func validMessage(idx: Int) -> String? {
        guard (0..<count).contains(idx) else {
            return nil
        }
        
        let result = index(startIndex, offsetBy: idx)
        
        return String(self[...result])
    }
    
}
