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
    case ios(query: String, receipt: String, product: String)
    
    var baseURL: URL {
        switch self {
        case .myInfo:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.User.base + SeSACAPI.User.Shop.base + SeSACAPI.User.Shop.myInfo)!
        case .ios:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.User.base + SeSACAPI.User.Shop.base + SeSACAPI.User.Shop.ios)!
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .myInfo(let query), .ios(let query, _, _):
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
        case .ios(_ , let receipt, let product):
            return [
                "receipt": receipt,
                "product": product
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case  .myInfo:
            return .get
        case .ios:
            return .post
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
        case .ios:
            return try URLEncoding(arrayEncoding: .noBrackets).encode(request, with: parameters)
        }
    }
}
