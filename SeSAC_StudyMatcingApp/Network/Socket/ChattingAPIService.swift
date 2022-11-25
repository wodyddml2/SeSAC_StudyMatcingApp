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
    
    var baseURL: URL {
        switch self {
        case .chatPost(_, let path, _):
            return URL(string: SeSACAPI.baseURL + SeSACAPI.chat + path)!
        }
        
    }
    
    var header: HTTPHeaders {
        switch self {
        case .chatPost(let query, _, _):
            return [
                "Content-Type": SeSACLoginHeader.contentType,
                "idtoken": query
            ]
        }
    }
    
    
    var parameters: Parameters {
        switch self {
        case .chatPost(_, _, let chat):
            return ["chat": chat]
        }
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .chatPost:
            return .post
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        switch self {
        case .chatPost:
            return try URLEncoding(arrayEncoding: .noBrackets).encode(request, with: parameters)
        }
        
    }
}

class ChattingAPIService {
    static let shared = ChattingAPIService()
    
    private init() { }
    
    
    
}
