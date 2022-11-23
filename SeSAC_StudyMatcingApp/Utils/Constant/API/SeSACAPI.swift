//
//  SeSACAPI.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/09.
//

import Foundation

enum SeSACAPI {
    static let baseURL = "http://api.sesac.co.kr:1210/v1"
    static let login = "/user"
    static let profileSave = "/user/mypage"
    static let withdraw = "/user/withdraw"
    static let search = "/queue/search"
    static let match = "/queue/myQueueState"
    static let find = "/queue"
    static let request = "/queue/studyrequest"
    static let accept = "/queue/studyaccept"
}

enum SeSACLoginHeader {
    static let contentType = "application/x-www-form-urlencoded"
    static let accept = "application/json"
}


