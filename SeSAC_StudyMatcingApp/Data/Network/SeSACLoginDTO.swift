//
//  SeSACLoginDTO.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/09.
//
import Foundation

struct SESACLoginDTO: Codable {
    let id: String
    let v: Int
    let uid, phoneNumber, email, fcmToken: String
    let nick, birth: String
    let gender: Int
    let study: String
    let comment: [String]
    let reputation: [Int]
    let sesac: Int
    let sesacCollection: [Int]
    let background: Int
    let backgroundCollection: [Int]
    let purchaseToken, transactionID, reviewedBefore: [String]
    let reportedNum: Int
    let reportedUser: [String]
    let dodgepenalty, dodgeNum, ageMin, ageMax: Int
    let searchable: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case uid, phoneNumber, email
        case fcmToken = "FCMtoken"
        case nick, birth, gender, study, comment, reputation, sesac, sesacCollection, background, backgroundCollection, purchaseToken
        case transactionID = "transactionId"
        case reviewedBefore, reportedNum, reportedUser, dodgepenalty, dodgeNum, ageMin, ageMax, searchable, createdAt
    }
}

extension SESACLoginDTO {
    func toDomain() -> SeSACProfile {
        return .init(backgroundImage: background, image: sesac, nickname: nick, sesacTitle: reputation, comment: comment, gender: gender, study: study, searchable: searchable, ageMin: ageMin, ageMax: ageMax)
    }
}

