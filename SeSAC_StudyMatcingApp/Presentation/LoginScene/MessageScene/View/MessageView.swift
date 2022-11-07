//
//  MessageView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

final class MessageView: LoginView {
//    let label: UILabel = {
//        let view = UILabel()
//        
//        return view
//    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        introLabel.text = "인증번호가 문자로 전송이 되었어요"
        numberTextField.placeholder = "인증번호 입력"
        authButton.setTitle("인증하고 시작하기", for: .normal)
    }
    
    override func configureUI() {
        
        [introLabel, numberTextField, numberView, authButton].forEach {
            self.addSubview($0)
        }
    }
    
}
