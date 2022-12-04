//
//  SeSACAPI.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/09.
//

import Foundation

enum SeSACAPI {
    static let baseURL = "http://api.sesac.co.kr:1210/"
    
    enum User {
        static let base = "v1/user"
        static let profileSave = "/mypage"
        static let withdraw = "/withdraw"
        static let fcm = "/update_fcm_token"
        enum Shop {
            static let base = "/shop"
            static let myInfo = "/myinfo"
            static let ios = "/ios"
        }
    }
    
    enum Queue {
        static let base = "v1/queue"
        static let search = "/search"
        static let match = "/myQueueState"
        static let request = "/studyrequest"
        static let accept = "/studyaccept"
        static let dodge = "/dodge"
        static let rate = "/rate"
    }

    static let chat = "v1/chat"
}

enum SeSACHeader {
    static let contentType = "application/x-www-form-urlencoded"
    static let accept = "application/json"
}


