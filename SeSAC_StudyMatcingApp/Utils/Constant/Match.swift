//
//  MatchImage.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/16.
//

import Foundation

enum MatchImage {
    static let antenna = "antenna"
    static let message = "message"
    static let search = "search"
}

enum MatchStatus: Int {
    case antenna = 0
    case message = 1
    case search = 201
}

enum MatchComment {
    static let alreadyPromised = "누군가와 스터디를 함께하기로 약속하셨어요!"
    static let togetherMatch = "상대방도 스터디를 요청하여 매칭되었습니다. 잠시 후 채팅방으로 이동합니다"
}
