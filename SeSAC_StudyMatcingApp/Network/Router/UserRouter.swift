//
//  UserRouter.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/12/01.
//

import Foundation

import Alamofire

enum UserRouter: URLRequestConvertible {
    case login(query: String)
    case signUp
    case save(sesac: SeSACProfile, query: String)
    case withdraw(query: String)
    case fcm(query: String, tokenFCM: String)
    
    var baseURL: URL {
        switch self {
        case .login, .signUp:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.User.base)!
        case .save:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.User.base + SeSACAPI.User.profileSave)!
        case .withdraw:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.User.base + SeSACAPI.User.withdraw)!
        case .fcm:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.User.base + SeSACAPI.User.fcm)!
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .login(let query), .save( _ ,let query), .withdraw(let query), .fcm(let query, _):
            return  [
                "Content-Type": SeSACHeader.contentType,
                "idtoken": query
            ]
        case .signUp:
            return [
                "Content-Type": SeSACHeader.contentType,
                "idtoken": UserManager.idToken
            ]
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .login, .withdraw:
            return ["":""]
        case .signUp:
            guard let gender = UserManager.gender else {return Parameters()}
            guard let birth = UserManager.birth else {return Parameters()}
            return [
                "phoneNumber": UserManager.phoneNumber.saveNumber(),
                "FCMtoken": UserManager.fcmToken,
                "nick": UserManager.nickname,
                "birth": birth.datePickerFormat(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") ,
                "email": UserManager.email,
                "gender": gender
            ]
        case .save(let sesac, _):
            return [
                "searchable": "\(sesac.searchable)",
                "ageMin": "\(sesac.ageMin)",
                "ageMax": "\(sesac.ageMax)",
                "gender": "\(sesac.gender)",
                "study": sesac.study
            ]
            
        case .fcm(_, let tokenFCM):
            return [
                "FCMtoken": tokenFCM
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .get
        case .signUp, .withdraw:
            return .post
        case .save, .fcm:
            return .put
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        switch self {
        case .login, .withdraw:
            return request
        case .signUp, .save, .fcm:
            return try URLEncoding(arrayEncoding: .noBrackets).encode(request, with: parameters)
        }
    }
}
