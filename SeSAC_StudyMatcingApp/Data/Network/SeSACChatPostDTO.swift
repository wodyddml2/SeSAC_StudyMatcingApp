//
//  SeSACChatPostDTO.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/25.
//

import Foundation

struct SeSACChatPostDTO: Codable {
    let id, to, from, chat: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case to, from, chat, createdAt
    }
}
