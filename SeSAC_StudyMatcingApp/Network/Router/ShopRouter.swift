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
    case item(query: String, sesac: String, background: String)
    
    var baseURL: URL {
        switch self {
        case .myInfo:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.User.base + SeSACAPI.User.Shop.base + SeSACAPI.User.Shop.myInfo)!
        case .ios:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.User.base + SeSACAPI.User.Shop.base + SeSACAPI.User.Shop.ios)!
        case .item:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.User.base + SeSACAPI.User.Shop.base + SeSACAPI.User.Shop.item)!
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .myInfo(let query), .ios(let query, _, _), .item(let query, _, _):
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
        case .item( _, let sesac, let background):
            return [
                "sesac": sesac,
                "background": background
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case  .myInfo:
            return .get
        case .ios, .item:
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
        case .ios, .item:
            return try URLEncoding(arrayEncoding: .noBrackets).encode(request, with: parameters)
        }
    }
}
