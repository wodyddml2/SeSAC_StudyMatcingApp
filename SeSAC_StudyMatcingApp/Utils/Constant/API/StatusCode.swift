//
//  StatusCode.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/23.
//

import Foundation

enum StatusCode: Int {
    case success = 200
    case declarationOrMatch = 201
    case stopFind = 202
    case cancelFirst = 203
    case cancelSecond = 204
    case cancelThird = 205
    case firebaseError = 401
    case noSignup = 406
    case ServerError = 500
    case ClientError = 501
}
