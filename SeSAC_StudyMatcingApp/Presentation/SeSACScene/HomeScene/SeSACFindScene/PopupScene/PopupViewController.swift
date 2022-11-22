//
//  PopupViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/22.
//

import UIKit

import RxSwift

class PopupViewController: BaseViewController {
    
    let mainView = PopupView()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.5)
        
        popupCustom()
        
        bindTo()
    }
    
    override func setConstraints() {
        mainView.popupView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.22)
        }
        
        mainView.cancelButton.snp.remakeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(mainView.snp.centerX).offset(-4)
            make.height.equalToSuperview().multipliedBy(0.26)
        }
        
        mainView.okButton.snp.remakeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(mainView.snp.centerX).offset(4)
            make.height.equalToSuperview().multipliedBy(0.26)
        }
    }
    
    func popupCustom() {
        mainView.titleText(
            title: "스터디를 요청할게요!",
            subTitle:
                    """
                    상대방이 요청을 수락하면
                    채팅창에서 대화를 나눌 수 있어요
                    """
        )
        
        mainView.subTitleLabel.textColor = .gray7
        mainView.cancelButton.backgroundColor = .gray2
        mainView.cancelButton.layer.borderWidth = 0
        
    }
    
    func bindTo() {
        mainView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
    }
}
