//
//  QueueRouter.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/12/01.
//

import Foundation

import Alamofire

enum QueueRouter: URLRequestConvertible {
    case search(query: String, lat: Double, long: Double)
    case match(query: String)
    case findPost(query: String, lat: Double, long: Double, list: [String])
    case findDelete(query: String)
    case request(query: String, uid: String)
    case accept(query: String, uid: String)
    case dodge(query: String, uid: String)
    case rate(query: String, uid: String, list: [Int], comment: String)
    
    
    var baseURL: URL {
        switch self {
        case .search:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.search)!
        case .match:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.match)!
        case .findPost, .findDelete:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.find)!
        case .request:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.request)!
        case .accept:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.accept)!
        case .dodge:
            return URL(string: SeSACAPI.baseURL + SeSACAPI.dodge)!
        case .rate(_, let uid, _, _):
            return URL(string: SeSACAPI.baseURL + SeSACAPI.rate + "/\(uid)")!
        }
        
    }
    
    var header: HTTPHeaders {
        switch self {
        case .match(let query), .search(let query, _, _), .findPost(let query, _, _, _), .findDelete(let query), .request(query: let query, _), .accept(let query, _), .dodge(let query, _), .rate(let query, _, _, _):
            return  [
                "Content-Type": SeSACHeader.contentType,
                "idtoken": query
            ]
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .match, .findDelete:
            return ["":""]
        case .search( _,let lat ,let long):
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
            
        case .request( _, let uid), .accept( _, let uid), .dodge( _, let uid):
            return ["otheruid": uid]
        case .rate(_ , let uid, let list, let comment):
            return [
                "otheruid": uid,
                "reputation": list,
                "comment": comment
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .match:
            return .get
        case .search, .findPost, .request, .accept, .dodge, .rate:
            return .post
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
        case .match, .findDelete:
            return request
        case .search, .findPost, .request, .accept, .dodge, .rate:
            return try URLEncoding(arrayEncoding: .noBrackets).encode(request, with: parameters)
        }
    }
}
