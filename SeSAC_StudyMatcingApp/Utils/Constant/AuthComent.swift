//
//  Coments.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/08.
//

import Foundation

enum AuthComent: String {
    case phoneAuth = "전화 번호 인증 시작"
    case resend = "인증번호를 재전송했습니다."
    case messageAuth = "인증번호를 보냈습니다."
    case invalidNumber = "잘못된 전화번호 형식입니다."
}
