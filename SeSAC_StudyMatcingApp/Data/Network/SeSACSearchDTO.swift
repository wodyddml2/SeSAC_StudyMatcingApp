//
//  SeSACSearchDTO.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/17.
//

import Foundation

struct SeSACSearchDTO: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

// MARK: - FromQueueDB
struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let studylist, reviews: [String]
    let gender, type, sesac, background: Int
}
