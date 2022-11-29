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
    var from: String
    var uid: String
    var originCreated: String
    
    init(message: String = "", createdAt: String = "", sectionDate: String = "", from: String = "", uid: String = "", originCreated: String = "") {
        self.message = message
        self.createdAt = createdAt
        self.sectionDate = sectionDate
        self.from = from
        self.uid = uid
        self.originCreated = originCreated
    }
}
