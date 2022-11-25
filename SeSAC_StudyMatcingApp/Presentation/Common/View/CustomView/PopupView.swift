//
//  PopupView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/25.
//

import UIKit

import RxSwift

class PopupView: BaseView {
    
    let disposeBag = DisposeBag()
    
    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .notoSans(size: 14, family: .Medium)
        view.textAlignment = .center
        return view
    }()
    
    let cancelButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.tintColor = .gray6
        return view
    }()
    
    let introLabel: UILabel = {
        let view = UILabel()
        view.textColor = .sesacGreen
        view.textAlignment = .center
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        return view
    }()
    
    let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray1
        view.layer.cornerRadius = 8
        return view
    }()
    
    let contentsTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .gray1
        view.textColor = .gray7
        return view
    }()
    
    let okButton: CommonButton = {
        let view = CommonButton()
        view.blockButton()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        [popupView, titleLabel, cancelButton, introLabel, contentsView, contentsTextView, okButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        popupView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(410)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(popupView.snp.top).offset(17)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(popupView.snp.trailing).offset(-16)
            make.height.width.equalTo(24)
        }
        
        introLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
        }
    }
}

extension PopupView {
    
    func normalStyle(title: String, intro: String = "", button: String) {
        titleLabel.text = title
        introLabel.text = intro
        okButton.setTitle(button, for: .normal)
    }
    
    func bindTextView(placeholder: String) {
        contentsTextView.rx.didBeginEditing
            .withUnretained(self)
            .bind { vc, _ in
                if vc.contentsTextView.textColor == .gray7 {
                    vc.contentsTextView.text = nil
                    vc.contentsTextView.textColor = .black
                }
            }
            .disposed(by: disposeBag)
        
        contentsTextView.rx.didEndEditing
            .withUnretained(self)
            .bind { vc, _ in
                if vc.contentsTextView.text == "" {
                    vc.contentsTextView.text = placeholder
                    vc.contentsTextView.textColor = .gray7
                }
            }
            .disposed(by: disposeBag)
    }
}
