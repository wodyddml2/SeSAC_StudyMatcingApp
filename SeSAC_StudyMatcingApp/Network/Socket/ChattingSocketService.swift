//
//  ChattingSocketService.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/24.
//

import Foundation

import SocketIO

class ChattingSocketService {
    static let shared = ChattingSocketService()
    
    var manager: SocketManager!
    
    var socket: SocketIOClient!
    
    private init() {
        
        manager = SocketManager(socketURL: URL(string: SocketKey.baseURL)!, config: [
            .log(true),
            .forceWebsockets(true)
        ])
        
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            guard let self = self else {return}
            self.socket.emit("changesocketid", UserManager.myUID)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            
        }

        socket.on("chat") { dataArray, ack in
            let data = dataArray[0] as! NSDictionary
            let id = data["_id"] as! String
            let chat = data["chat"] as! String
            let otherId = data["to"] as! String
            let userId = data["from"] as! String
            let createdAt = data["createdAt"] as! String

            NotificationCenter.default.post(
                name: Notification.Name("getMessage"),
                object: self,
                userInfo: ["id": id, "chat": chat, "otherId": otherId, "createdAt": createdAt, "userId": userId]
            )
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}

enum SocketNotificationName {
    static let id = "id"
    static let chat = "chat"
    static let otherId = "otherId"
    static let userId = "userId"
    static let createdAt = "createdAt"
    static let getMessage = "getMessage"
}
