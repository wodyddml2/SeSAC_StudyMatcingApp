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
    @Persisted var sectionDate: String
    @Persisted var from: String
    @Persisted var uid: String
    @Persisted var originCreated: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(message: String, createdAt: String, sectionDate: String, from: String, uid: String, originCreated: String) {
        self.init()
        self.message = message
        self.createdAt = createdAt
        self.sectionDate = sectionDate
        self.from = from
        self.uid = uid
        self.originCreated = originCreated
    }
}
