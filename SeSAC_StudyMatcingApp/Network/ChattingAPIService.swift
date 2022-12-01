//
//  ChattingAPIService.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/25.
//

import Foundation

import Alamofire

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
