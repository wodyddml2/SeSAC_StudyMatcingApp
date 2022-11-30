//
//  SeSACReviewView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/25.
//

import UIKit

import RxSwift
import RxKeyboard

class SeSACReviewView: PopupView {
    
    var reviewButtonList: [Int] = Array(repeating: 0, count: 8)
    var reviewButtonSelected: [Bool] = Array(repeating: false, count: 6)
    
    let stackView: ReviewStackView = {
        let view = ReviewStackView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentsTextView.text = "자세한 피드백은 다른 새싹들에게 큰 도움이 됩니다."
        
        normalStyle(title: "리뷰 등록", button: "리뷰 등록하기")
        
        bindTextView(placeholder: "자세한 피드백은 다른 새싹들에게 큰 도움이 됩니다.")
        bindKeyboard()
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
    
    func bindKeyboard() {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        let extra = window!.safeAreaInsets.bottom - 10
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive (onNext: { [weak self] height in
                guard let self = self else {return}
                UIView.animate(withDuration: 0) {
                    self.popupView.snp.remakeConstraints { make in
                        make.leading.trailing.equalToSuperview().inset(16)
                        make.height.equalTo(450)
                        make.bottom.equalTo(self.safeAreaLayoutGuide).inset(height - extra)
                    }
                }
                self.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    func selectedAction(button: CommonButton) {
        let index = button.tag
        reviewButtonSelected[index].toggle()
        if reviewButtonSelected[index] {
            button.selectedStyle()
            reviewButtonList[index] = 1
        } else {
            button.normalStyle(width: 1)
            reviewButtonList[index] = 0
        }
        
        if reviewButtonList.contains(1) {
            okButton.selectedStyle()
        } else {
            okButton.blockButton()
        }
    }
    
}
