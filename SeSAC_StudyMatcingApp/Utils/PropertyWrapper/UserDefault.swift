//
//  UserDefault.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let storages: UserDefaults
    
    var wrappedValue: T {
        get { self.storages.object(forKey: self.key) as? T ?? self.defaultValue }
        set { self.storages.set(newValue, forKey: self.key)}
    }
    
    init(key: String, defaultValue: T, storages: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storages = storages
    }
}

class UserManager {
    @UserDefault(key: "onboarding", defaultValue: false)
    static var onboarding: Bool
    
    @UserDefault(key: "authVerificationID", defaultValue: "")
    static var authVerificationID: String
    
    @UserDefault(key: "phoneNumber", defaultValue: "")
    static var phoneNumber: String
    
    @UserDefault(key: "idToken", defaultValue: "") // 나중에 지울 수도 있음
    static var idToken: String
    
    @UserDefault(key: "login", defaultValue: 0)
    static var login: Int
    
    @UserDefault(key: "nickname", defaultValue: "")
    static var nickname: String
    
    @UserDefault(key: "birth", defaultValue: "")
    static var birth: String
    
    @UserDefault(key: "email", defaultValue: "")
    static var email: String
    
    @UserDefault(key: "gender", defaultValue: nil)
    static var gender: String?
    
    @UserDefault(key: "FCMToken", defaultValue: "")
    static var fcmToken: String
    
    @UserDefault(key: "nickError", defaultValue: false)
    static var nickError: Bool
}

