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

extension SeSACChatPostDTO {
    func toDomain(dateFormat: String) -> SeSACChat {
        return .init(message: chat,
                     createdAt: createdAt.toDate().dateStringFormat(date: dateFormat),
                     sectionDate: createdAt.toDate().dateStringFormat(date: "M월 d일 EEEE"),
                     from: from,
                     uid: to,
                     originCreated: createdAt)
    }
}
