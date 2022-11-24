//
//  ChattingSocketService.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/24.
//

import Foundation

import SocketIO

class ChattingSocketService {
    static let shared = ChattingViewController()
    
    var manager: SocketManager!
    
    var socket: SocketIOClient!
    
    private init() {
        
        manager = SocketManager(socketURL: URL(string: "")!, config: [
            .log(true),
            .extraHeaders(["": ""])
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
            
//            NotificationCenter.default.post(
//                name: Notification.Name("getMessage"),
//                object: self,
//                userInfo: ["chat": chat, "name": name, "createdAt": createdAt, "userId": userId]
//            )
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
