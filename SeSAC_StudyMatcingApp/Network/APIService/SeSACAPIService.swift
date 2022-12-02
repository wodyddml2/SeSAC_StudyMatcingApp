//
//  SeSACAPIService.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/09.
//

import Foundation

import Alamofire

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
        AF.request(router).responseString { response in
           
            guard let statusCode = response.response?.statusCode else {return}
            
            completion(statusCode)
            
        }
    }
}
