//
//  NumberView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit
 
class NumberView: LoginView {
    
    let numberView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray3
        return view
    }()
    
    let numberTextField: UITextField = {
        let view = UITextField()
        view.keyboardType = .numberPad
        view.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        introLabel.text =
            """
            새싹 서비스 이용을 위해
            휴대폰 번호를 입력해 주세요
            """
        authButton.setTitle("인증 문자 받기", for: .normal)
    }
    
    override func configureUI() {
        super.configureUI()
        
        [numberTextField, numberView].forEach {
            self.addSubview($0)
        }
    }

    override func setConstraints() {
        super.setConstraints()
        
        numberTextField.snp.makeConstraints { make in
            make.bottom.equalTo(authButton.snp.bottom).multipliedBy(0.74)
            make.leading.equalTo(28)
            make.trailing.equalTo(-28)
            make.height.equalTo(48)
        }

        numberView.snp.makeConstraints { make in
            make.top.equalTo(numberTextField.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(1)
        }
    }
}
