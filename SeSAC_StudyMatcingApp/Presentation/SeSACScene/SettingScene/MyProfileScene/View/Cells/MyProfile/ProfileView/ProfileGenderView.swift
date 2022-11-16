//
//  GenderView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/15.
//

import UIKit

class ProfileGenderView: BaseView {
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = MyProfileText.gender
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        return view
    }()
    
    let manButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("남자", for: .normal)
        view.tag = 1
        return view
    }()
    
    let womanButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("여자", for: .normal)
        view.tag = 0
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [manButton, womanButton])
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        [titleLabel, stackView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
        }
    }
}
