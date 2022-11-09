//
//  MessageView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

final class MessageView: LoginView {

    let numberView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray3
        return view
    }()
    
    let numberTextField: UITextField = {
        let view = UITextField()
        view.keyboardType = .numberPad
        return view
    }()
    
    let resendButton: UIButton = {
        let view = UIButton()
        view.setTitle("재전송", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .sesacGreen
        view.layer.cornerRadius = 8
        return view
    }()
    
    let timerLabel: UILabel = {
        let view = UILabel()
        view.text = "01:00"
        view.font = UIFont.notoSans(size: 14, family: .Medium)
        view.textAlignment = .right
        view.textColor = .sesacGreen
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        introLabel.text = "인증번호가 문자로 전송이 되었어요"
        numberTextField.placeholder = "인증번호 입력"
        authButton.setTitle("인증하고 시작하기", for: .normal)
    }
    
    override func configureUI() {
        super.configureUI()
        [resendButton, timerLabel, numberView, numberTextField].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        numberTextField.snp.makeConstraints { make in
            make.bottom.equalTo(authButton.snp.bottom).multipliedBy(0.74)
            make.leading.equalTo(28)
            make.trailing.equalTo(-150)
            make.height.equalTo(48)
        }
        
        numberView.snp.makeConstraints { make in
            make.top.equalTo(numberTextField.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.equalTo(-96)
            make.height.equalTo(1)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.trailing.equalTo(resendButton.snp.leading).offset(-20)
            make.bottom.equalTo(numberView.snp.top).offset(-12)
        }
        
        resendButton.snp.makeConstraints { make in
            make.trailing.equalTo(-16)
            make.leading.equalTo(numberView.snp.trailing).offset(8)
            make.bottom.equalTo(numberView.snp.bottom)
            make.height.equalTo(40)
        }
        
    }
    
}
