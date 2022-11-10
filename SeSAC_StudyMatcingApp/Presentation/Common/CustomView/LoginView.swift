//
//  LoginView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/08.
//

import UIKit
 
class LoginView: BaseView {
    
    let introLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.textAlignment = .center
        view.font = UIFont.notoSans(size: 20, family: .Regular)
        return view
    }()
    
    let authButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .gray6
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureUI() {
        [introLabel, authButton].forEach {
            self.addSubview($0)
        }
    }
    
    func baseUI(labelText: String, buttonText: String) {
        introLabel.text = labelText
        authButton.setTitle(buttonText, for: .normal)
    }
    
    override func setConstraints() {
        introLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).multipliedBy(1.75)
            make.centerX.equalTo(self)
        }
        
        authButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).multipliedBy(0.57)
            make.trailing.leading.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
