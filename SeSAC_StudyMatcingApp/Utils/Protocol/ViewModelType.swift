//
//  ViewModelType.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import Foundation

import FirebaseAuth
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
  
}

extension ViewModelType {
    func validateEmail(_ text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z]{2,16}+@[A-Za-z0-9]{4,16}+\\.[A-Za-z]{2,10}"
        return text.range(of: emailRegEx, options: .regularExpression) != nil
    }
    
    func renwalGetIdToken(completion: @escaping () -> Void) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if error != nil {
                return
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                completion()
            }
        }
    }
}
