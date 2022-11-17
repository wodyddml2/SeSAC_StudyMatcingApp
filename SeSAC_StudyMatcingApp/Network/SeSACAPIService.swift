//
//  SeSACAPIService.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/09.
//

import Foundation

import Alamofire

enum Router: URLRequestConvertible {
    case loginGet(query: String)
    case signUpPost
    case savePut(sesac: SeSACProfileGet, query: String)
    case withdrawPost(query: String)
    
    
    var baseURL: URL {
        switch self {
        case .loginGet, .signUpPost:
            return URL(string: SeSACAPI.loginURL)!
        case .savePut:
            return URL(string: SeSACAPI.profileSaveURL)!
        case .withdrawPost:
            return URL(string: SeSACAPI.withdrawURL)!
        }
        
    }
    
    var header: HTTPHeaders {
        switch self {
        case .loginGet(let query):
            return  [
                "Content-Type": SeSACLoginHeader.contentType,
                "accept": SeSACLoginHeader.accept,
                "idtoken": query
            ]
        case .signUpPost:
            return [
                "Content-Type": SeSACLoginHeader.contentType,
                "idtoken": UserManager.idToken
            ]
        case .savePut( _ ,let query), .withdrawPost(query: let query):
            return [
                "Content-Type": SeSACLoginHeader.contentType,
                "idtoken": query
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
            return try URLEncoding.default.encode(request, with: parameters)
        }
        
    }
}

enum SeSACLoginError: Int, Error {
    case notNickname = 202
    case existingUsers = 201
    case firebaseTokenError = 401
    case noSignup = 406
    case serverError = 500
    case clientError = 501
    case success = 200
}

extension SeSACLoginError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .firebaseTokenError, .serverError, .clientError:
            return "에러가 발생했습니다. 다시 시도해주세요"
        case .noSignup, .success:
            return ""
        case .notNickname:
            return "사용할 수 없는 닉네임입니다."
        case .existingUsers:
            return "이미 가입한 유저입니다."
        }
    }
}

class SeSACAPIService {
    static let shared = SeSACAPIService()
    
    private init() { }
    
    func requestSeSACLogin<T: Codable>(type: T.Type = T.self, router: URLRequestConvertible ,completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(router).responseDecodable(of: T.self) { response in
           
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(_):
                guard let statusCode = response.response?.statusCode else {return}
                print(statusCode)
                guard let error = SeSACLoginError(rawValue: statusCode) else {return}
                completion(.failure(error))
            }
        }
    }
    
    
}
