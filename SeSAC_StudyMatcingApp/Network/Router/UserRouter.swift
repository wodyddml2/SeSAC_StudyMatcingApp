//
//  UserRouter.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/12/01.
//

import Foundation

import Alamofire

enum UserRouter: URLRequestConvertible {
    case loginGet(query: String)
    case signUpPost
    case savePut(sesac: SeSACProfile, query: String)
    case withdrawPost(query: String)
    
    var baseURL: URL {
        switch self {
        case .loginGet, .signUpPost:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.login)!
        case .savePut:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.profileSave)!
        case .withdrawPost:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.withdraw)!
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .loginGet(let query), .savePut( _ ,let query), .withdrawPost(let query):
            return  [
                "Content-Type": SeSACHeader.contentType,
                "idtoken": query
            ]
        case .signUpPost:
            return [
                "Content-Type": SeSACHeader.contentType,
                "idtoken": UserManager.idToken
            ]
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .loginGet, .withdrawPost:
            return ["":""]
        case .signUpPost:
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
        case .savePut(let sesac, _):
            return [
                "searchable": "\(sesac.searchable)",
                "ageMin": "\(sesac.ageMin)",
                "ageMax": "\(sesac.ageMax)",
                "gender": "\(sesac.gender)",
                "study": sesac.study
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loginGet:
            return .get
        case .signUpPost, .withdrawPost:
            return .post
        case .savePut:
            return .put
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        switch self {
        case .loginGet, .withdrawPost:
            return request
        case .signUpPost, .savePut:
            return try URLEncoding(arrayEncoding: .noBrackets).encode(request, with: parameters)
        }
    }
}