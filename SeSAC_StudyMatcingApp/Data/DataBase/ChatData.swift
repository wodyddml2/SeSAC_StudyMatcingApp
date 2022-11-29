//
//  ChatData.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/28.
//

import Foundation

import RealmSwift

class ChatData: Object {
    @Persisted var message: String
    @Persisted var createdAt: String
    @Persisted var from: String
    @Persisted var uid: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(message: String, createdAt: String, from: String, uid: String) {
        self.init()
        self.message = message
        self.createdAt = createdAt
        self.from = from
        self.uid = uid
    }
}
