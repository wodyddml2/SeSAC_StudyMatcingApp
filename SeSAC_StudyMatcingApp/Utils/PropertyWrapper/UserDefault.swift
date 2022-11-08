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
}

