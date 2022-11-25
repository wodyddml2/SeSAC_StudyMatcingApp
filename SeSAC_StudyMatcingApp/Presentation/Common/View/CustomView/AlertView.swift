//
//  PopupView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/21.
//

import UIKit

class AlertView: BaseView {
    
    let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "정말 탈퇴하시겠습니까?"
        view.font = UIFont.notoSans(size: 16, family: .Medium)
        view.textAlignment = .center
        return view
    }()
    
    let subTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ"
        view.numberOfLines = 0
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        view.textAlignment = .center
        return view
    }()
    
    let cancelButton: CommonButton = {
        let view = CommonButton()
        view.normalStyle(width: 1)
        view.setTitle("취소", for: .normal)
        return view
    }()
    
    let okButton: CommonButton = {
        let view = CommonButton()
        view.selectedStyle()
        view.setTitle("확인", for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func titleText(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    override func configureUI() {
        self.addSubview(alertView)
        
        [titleLabel, subTitleLabel, cancelButton, okButton].forEach {
            alertView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.19)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(self.snp.centerX).offset(-4)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        okButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(self .snp.centerX).offset(4)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
}
