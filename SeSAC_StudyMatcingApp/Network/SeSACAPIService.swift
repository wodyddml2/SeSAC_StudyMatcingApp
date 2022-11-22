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
    case savePut(sesac: SeSACProfile, query: String)
    case withdrawPost(query: String)
    case searchPost(query: String, lat: Double, long: Double)
    case matchGet(query: String)
    case findPost(query: String, lat: Double, long: Double, list: [String])
    case findDelete(query: String)
    
    
    var baseURL: URL {
        switch self {
        case .loginGet, .signUpPost:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.login)!
        case .savePut:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.profileSave)!
        case .withdrawPost:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.withdraw)!
        case .searchPost:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.search)!
        case .matchGet:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.match)!
        case .findPost, .findDelete:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.find)!
        }
        
    }
    
    var header: HTTPHeaders {
        switch self {
        case .loginGet(let query), .matchGet(let query), .savePut( _ ,let query), .withdrawPost(let query), .searchPost(let query, _, _), .findPost(let query, _, _, _), .findDelete(let query):
            return  [
                "Content-Type": SeSACLoginHeader.contentType,
                "idtoken": query
            ]
        case .signUpPost:
            return [
                "Content-Type": SeSACLoginHeader.contentType,
                "idtoken": UserManager.idToken
            ]
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .loginGet, .withdrawPost, .matchGet, .findDelete:
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
        case .searchPost( _,let lat ,let long):
            return [
                "lat": "\(lat)",
                "long": "\(long)"
            ]
        case .findPost( _,let lat ,let long, let list):
            if list.isEmpty {
                return [
                    "lat": "\(lat)",
                    "long": "\(long)",
                    "studylist": "anything"
                ]
            } else {
                return [
                    "lat": "\(lat)",
                    "long": "\(long)",
                    "studylist": list
                ]
            }
           
        }
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .loginGet, .matchGet:
            return .get
        case .signUpPost, .withdrawPost, .searchPost, .findPost:
            return .post
        case .savePut:
            return .put
        case .findDelete:
            return .delete
        }
        
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        switch self {
        case .loginGet, .withdrawPost, .matchGet, .findDelete:
            return request
        case .signUpPost, .savePut, .searchPost, .findPost:
            return try URLEncoding(arrayEncoding: .noBrackets).encode(request, with: parameters)
        }
        
    }
}

enum StatusCode: Int {
    case success = 200
    case declarationOrMatch = 201
    case cancelFirst = 203
    case cancelSecond = 204
    case cancelThird = 205
    case firebaseError = 401
    case noSignup = 406
    case ServerError = 500
    case ClientError = 501
}

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

class SeSACAPIService {
    static let shared = SeSACAPIService()
    
    private init() { }
    
    func requestSeSACAPI<T: Codable>(type: T.Type = T.self, router: URLRequestConvertible ,completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(router).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(_):
                guard let statusCode = response.response?.statusCode else {return}
                guard let error = SeSACError(rawValue: statusCode) else {return}
                completion(.failure(error))
            }
        }
    }
    
    func requestStatusSeSACAPI(router: URLRequestConvertible ,completion: @escaping (Int) -> Void) {
        AF.request(router).responseDecodable(of: String.self) { response in
           
            guard let statusCode = response.response?.statusCode else {return}
            
            completion(statusCode)
            
        }
    }
    
    
}
