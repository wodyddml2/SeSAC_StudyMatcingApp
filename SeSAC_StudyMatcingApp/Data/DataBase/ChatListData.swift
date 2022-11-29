//
//  ChatListData.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/28.
//

import Foundation

import RealmSwift

class ChatListData: Object {
    @Persisted var chatInfo: List<ChatData>
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(chatInfo: List<ChatData>) {
        self.init()
        self.chatInfo = chatInfo
    }
}
