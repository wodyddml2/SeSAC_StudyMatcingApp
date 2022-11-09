//
//  SeSACAPI.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/09.
//

import Foundation

enum SeSACAPI {
    static let baseURL = "http://api.sesac.co.kr:1207"
    static let loginURL = "http://api.sesac.co.kr:1207/v1/user"
}

enum SeSACLoginHeader {
    static let contentType = "application/x-www-form-urlencoded"
    static let accept = "application/json"
}


