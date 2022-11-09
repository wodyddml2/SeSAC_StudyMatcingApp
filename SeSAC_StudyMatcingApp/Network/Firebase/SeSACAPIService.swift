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
    
    
    var baseURL: URL {
        return URL(string: SeSACAPI.loginURL)!
    }
    
    var header: HTTPHeaders {
        switch self {
        case .loginGet(let query):
            return [
                "Content-Type": SeSACLoginHeader.contentType,
                "accept": SeSACLoginHeader.accept,
                "idtoken": query
            ]
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        return request
    }
}

enum SeSACLoginError: Int, Error {
    case firebaseTokenError = 401
    case noSignup = 406
    case serverError = 500
    case clientError = 501
}

extension SeSACLoginError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .firebaseTokenError, .serverError, .clientError:
            return "에러가 발생했습니다. 다시 시도해주세요"
        case .noSignup:
            return ""
        }
    }
}

class SeSACAPIService {
    static let shared = SeSACAPIService()
    
    private init() { }
    
    func requestSeSACLogin(query: String, completion: @escaping (Result<SESACLoginDTO, Error>) -> Void) {
        AF.request(Router.loginGet(query: query)).responseDecodable(of: SESACLoginDTO.self) { response in
  
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(_):
                guard let statusCode = response.response?.statusCode else {return}
                guard let error = SeSACLoginError(rawValue: statusCode) else {return}
                completion(.failure(error))
            }
        }
    }
    
    
}
