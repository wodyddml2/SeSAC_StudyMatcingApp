//
//  SeSACError.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/23.
//

import Foundation

enum SeSACError: Int, Error {
    case notNickname = 202
    case existingUsers = 201
    case firebaseTokenError = 401
    case noSignup = 406
    case serverError = 500
    case clientError = 501
}

extension SeSACError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .firebaseTokenError, .serverError, .clientError:
            return "에러가 발생했습니다. 다시 시도해주세요"
        case .noSignup:
            return ""
        case .notNickname:
            return "사용할 수 없는 닉네임입니다."
        case .existingUsers:
            return "이미 가입한 유저입니다."
        }
    }
}
