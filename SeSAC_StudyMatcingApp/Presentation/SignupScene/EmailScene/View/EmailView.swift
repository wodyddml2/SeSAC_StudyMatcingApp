//
//  EmailView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import UIKit

class EmailView: LoginView {
    let emailIntroLabel: UILabel = {
        let view = UILabel()
        view.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        view.textColor = .gray7
        view.textAlignment = .center
        view.font = UIFont.notoSans(size: 16, family: .Regular)
        return view
    }()
    
    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray3
        return view
    }()
    
    let emailTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "SeSAC@email.com"
        view.becomeFirstResponder()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseUI(labelText: "이메일을 입력해 주세요", buttonText: "다음")
    }
    
    override func configureUI() {
        super.configureUI()
        
        [emailIntroLabel, underlineView, emailTextField].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        emailIntroLabel.snp.makeConstraints { make in
            make.top.equalTo(introLabel.snp.bottom).offset(8)
            make.centerX.equalTo(self)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.bottom.equalTo(authButton.snp.bottom).multipliedBy(0.74)
            make.leading.equalTo(28)
            make.trailing.equalTo(-28)
            make.height.equalTo(48)
        }

        underlineView.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(1)
        }
    }
}
