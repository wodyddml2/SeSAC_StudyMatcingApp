//
//  SeSACChat.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/23.
//

import Foundation

struct SeSACChat {
    var message: String
    var createdAt: String
    var sectionDate: String
    var uid: String
    
    init(message: String = "", createdAt: String = "", sectionDate: String = "", uid: String = "") {
        self.message = message
        self.createdAt = createdAt
        self.sectionDate = sectionDate
        self.uid = uid
    }
}
