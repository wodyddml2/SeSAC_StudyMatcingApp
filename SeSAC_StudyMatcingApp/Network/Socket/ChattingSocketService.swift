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
        
        manager = SocketManager(socketURL: URL(string: SocketKey.baseURL + SocketKey.chat)!, config: [
            .log(true)
        ])
        
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
        socket.on("sesac") { dataArray, ack in
            print("SESAC RECEIVED", dataArray, ack)
            
           let data = dataArray[0] as! NSDictionary
            let chat = data["chat"] as! String
            let otherId = data["to"] as! String
            let userId = data["from"] as! String
            let createdAt = data["createdAt"] as! String
            
            print("CHECK >>>", chat, userId, createdAt)
            
            NotificationCenter.default.post(
                name: Notification.Name("getMessage"),
                object: self,
                userInfo: ["chat": chat, "otherId": otherId, "createdAt": createdAt, "userId": userId]
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
