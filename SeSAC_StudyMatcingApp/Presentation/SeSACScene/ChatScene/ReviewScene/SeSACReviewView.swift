//
//  SeSACReviewView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/25.
//

import UIKit

class SeSACReviewView: PopupView {
    
    let stackView: ReviewStackView = {
        let view = ReviewStackView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        normalStyle(title: "리뷰 등록", button: "리뷰 등록하기")
    }
    
    override func configureUI() {
        super.configureUI()
        
        self.addSubview(stackView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        popupView.snp.updateConstraints { make in
            make.height.equalTo(450)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(introLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(popupView).inset(16)
            make.height.equalTo(112)
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
