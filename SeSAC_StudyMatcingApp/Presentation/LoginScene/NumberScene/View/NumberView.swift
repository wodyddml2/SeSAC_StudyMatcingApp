//
//  NumberView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit
 
final class NumberView: BaseView {
    
    let introLabel: UILabel = {
        let view = UILabel()
        view.text =
            """
            새싹 서비스 이용을 위해
            휴대폰 번호를 입력해 주세요
            """
        view.numberOfLines = 2
        view.textAlignment = .center
        view.font = UIFont.notoSans(size: 20, family: .Regular)
        return view
    }()
    
    let numberView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray3
        return view
    }()
    
    let numberTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        view.keyboardType = .numberPad
        return view
    }()
    
    let authButton: UIButton = {
        let view = UIButton()
        view.setTitle("인증 문자 받기", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .gray6
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        [introLabel, numberTextField, numberView, authButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        introLabel.snp.makeConstraints { make in
            make.top.equalTo(169)
            make.centerX.equalTo(self)
        }
        
        numberTextField.snp.makeConstraints { make in
            make.top.equalTo(introLabel.snp.bottom).offset(77)
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
        
        authButton.snp.makeConstraints { make in
            make.top.equalTo(numberView.snp.bottom).offset(72)
            make.centerX.equalTo(self)
            make.width.equalTo(numberView.snp.width)
            make.height.equalTo(48)
        }
    }
}
