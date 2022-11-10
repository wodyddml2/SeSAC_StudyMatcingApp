//
//  NicknameView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import UIKit

final class NicknameView: LoginView {
    
    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray3
        return view
    }()
    
    let nicknameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "10자 이내로 입력"
        view.becomeFirstResponder()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        baseUI(labelText: "닉네임을 입력해 주세요", buttonText: "다음")
    }
    
    override func configureUI() {
        super.configureUI()
        
        [nicknameTextField, underlineView].forEach {
            self.addSubview($0)
        }
    }


    override func setConstraints() {
        super.setConstraints()
        
        nicknameTextField.snp.makeConstraints { make in
            make.bottom.equalTo(authButton.snp.bottom).multipliedBy(0.74)
            make.leading.equalTo(28)
            make.trailing.equalTo(-28)
            make.height.equalTo(48)
        }

        underlineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(1)
        }
    }
}
