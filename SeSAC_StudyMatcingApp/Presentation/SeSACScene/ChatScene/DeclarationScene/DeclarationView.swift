//
//  DeclarationView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/25.
//

import UIKit

class DeclarationView: PopupView {
    
    let illegalButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("불법/ 사기", for: .normal)
        return view
    }()
    
    let wordButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("불편한언행", for: .normal)
        return view
    }()
    
    let noShowButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("노쇼", for: .normal)
        return view
    }()
    
    let sensualityButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("선정성", for: .normal)
        return view
    }()
    
    let personalAttackButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("인신공격", for: .normal)
        return view
    }()
    
    let etcButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("기타", for: .normal)
        return view
    }()
    
    lazy var topStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [illegalButton, wordButton, noShowButton])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 8
        return view
    }()
    
    lazy var bottomStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [sensualityButton, personalAttackButton, etcButton])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 8
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        normalStyle(title: "새싹 신고", intro: "다시는 해당 새싹과 매칭되지 않습니다", button: "신고하기")
    }

    override func configureUI() {
        super.configureUI()
        
        self.addSubview(stackView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(introLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(popupView).inset(16)
            make.height.equalTo(72)
        }
        
        contentsView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(popupView).inset(16)
            make.height.equalTo(124)
        }
        
        contentsTextView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentsView).inset(14)
            make.leading.trailing.equalTo(contentsView).inset(12)
        }
        
        okButton.snp.makeConstraints { make in
            make.top.equalTo(contentsView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(popupView).inset(16)
            make.height.equalTo(48)
        }
    }
}
