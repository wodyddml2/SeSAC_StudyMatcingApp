//
//  ChattingAPIService.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/25.
//

import Foundation

import Alamofire

enum ChatRouter: URLRequestConvertible {
    case chatPost(query: String, path: String, chat: String)
    case chatGet(query: String, path: String, lastchatDate: String)
    
    var baseURL: URL {
        switch self {
        case .chatPost(_, let path, _):
            return URL(string: SeSACAPI.baseURL + SeSACAPI.chat + "/\(path)")!
        case .chatGet(_, path: let path, _):
            return URL(string: SeSACAPI.baseURL + SeSACAPI.chat + "/\(path)")!
        }
        
    }
    
    var header: HTTPHeaders {
        switch self {
        case .chatPost(let query, _, _), .chatGet(let query, _, _):
            return [
                "Content-Type": SeSACHeader.contentType,
                "idtoken": query
            ]
        }
    }
    
    
    var parameters: Parameters {
        switch self {
        case .chatPost(_, _, let chat):
            return ["chat": chat]
        case .chatGet(_, _, let lastchatDate):
            return ["lastchatDate": lastchatDate]
        }
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .chatPost:
            return .post
        case .chatGet:
            return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        switch self {
        case .chatPost, .chatGet:
            return try URLEncoding(arrayEncoding: .noBrackets).encode(request, with: parameters)
        }
        
    }
}

class ChattingAPIService {
    static let shared = ChattingAPIService()
    
    private init() { }
    
    func requestGETAPI(router: URLRequestConvertible ,completion: @escaping (Result<SeSACChatGetDTO, Error>) -> Void) {
        AF.request(router).responseDecodable(of: SeSACChatGetDTO.self) { response in
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
    
    func requestPOSTAPI(router: URLRequestConvertible ,completion: @escaping (Result<SeSACChatPostDTO, Error>) -> Void) {
        AF.request(router).responseDecodable(of: SeSACChatPostDTO.self) { response in
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
    
}
