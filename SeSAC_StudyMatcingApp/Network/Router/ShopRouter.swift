//
//  ShopRouter.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/12/04.
//

import Foundation

import Alamofire

enum ShopRouter: URLRequestConvertible {
    case myInfo(query: String)
    
    var baseURL: URL {
        switch self {
        case .myInfo:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.User.base + SeSACAPI.User.Shop.base + SeSACAPI.User.Shop.myInfo)!
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .myInfo(let query):
            return  [
                "Content-Type": SeSACHeader.contentType,
                "idtoken": query
            ]
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .myInfo:
            return ["":""]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case  .myInfo:
            return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        switch self {
        case .myInfo:
            return request
        }
    }
}
