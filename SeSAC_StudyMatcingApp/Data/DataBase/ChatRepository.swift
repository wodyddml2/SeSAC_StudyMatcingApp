//
//  ChatRepository.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/28.
//

import Foundation

import RealmSwift

class ChatRepository {
    let localRealm = try! Realm()
    
    func fetchFilter(uid: String) -> Results<ChatListData> {
        return localRealm.objects(ChatListData.self).filter("uid == %@", uid)
    }

    func addRealm(item: ChatListData) throws {
        try localRealm.write {
            localRealm.add(item)
        }
    }
   
    func deleteRealm() throws {
        try localRealm.write {
            localRealm.deleteAll()
        }
    }
    
    func appendChat(list: ChatListData, item: ChatData) throws {
        try localRealm.write {
            list.chatInfo.append(item)
        }
    }
}
