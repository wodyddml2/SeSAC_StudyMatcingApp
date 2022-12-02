//
//  Comment.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import Foundation

enum Comment {
    enum Signup {
        static let nicknameValid = "닉네임은 1자 이상 10자 이내로 부탁드려요."
        static let birthValid = "새싹스터디는 만 17세 이상만 사용할 수 있습니다."
        static let emailValid = "이메일 형식이 올바르지 않습니다."
    }
    
    enum Auth: String {
        case phoneAuth = "전화 번호 인증 시작"
        case resend = "인증번호를 재전송했습니다."
        case messageAuth = "인증번호를 보냈습니다."
        case invalidNumber = "잘못된 전화번호 형식입니다."
    }
    
    enum Penalty {
        static let unavailable = "신고가 누적되어 이용하실 수 없습니다"
        static let oneMinute = "스터디 취소 패널티로, 1분동안 이용하실 수 없습니다"
        static let twoMinute = "스터디 취소 패널티로, 2분동안 이용하실 수 없습니다"
        static let threeMintue = "스터디 취소 패널티로, 3분동안 이용하실 수 없습니다"
    }
    
    enum Match {
        static let alreadyPromised = "누군가와 스터디를 함께하기로 약속하셨어요!"
        static let togetherMatch = "상대방도 스터디를 요청하여 매칭되었습니다. 잠시 후 채팅방으로 이동합니다"
    }
    
    enum StudyRegistration {
        static let overlap = "스터디를 중복해서 등록할 수 없습니다."
        static let overStudy = "8개 이상 스터디를 등록할 수 없습니다."
        static let characterLimit = "최소 한 자 이상, 최대 8글자까지 작성 가능합니다"
    }
}


