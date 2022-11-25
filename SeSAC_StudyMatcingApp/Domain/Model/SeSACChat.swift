//
//  SeSACChat.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/23.
//

import Foundation

struct SeSACChat {
    var message: String
    var createdAt: Date
    
    init(message: String = "", createdAt: Date = Date()) {
        self.message = message
        self.createdAt = createdAt
    }
}
