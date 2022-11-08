//
//  FirebaseAPI.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/09.
//

import Foundation

import FirebaseAuth

class FirebaseAPIService {
    
    static let shared = FirebaseAPIService()
    
    private init() { }
    
    func requestAuth(phoneNumber: String, completion: @escaping (Result<String, FirebaseError>) -> Void) {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    let code = (error as NSError).code
                    switch code {
                    case 17010:
                        completion(.failure(.tooManyRequest))
                    default:
                        completion(.failure(.etc))
                    }
                    return
                }
                if let verificationID  = verificationID {
                    completion(.success(verificationID))
                }
                
            }
    }
}
