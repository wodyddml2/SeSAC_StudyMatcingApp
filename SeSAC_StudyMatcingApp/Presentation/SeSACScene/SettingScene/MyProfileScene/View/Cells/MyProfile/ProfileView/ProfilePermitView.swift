//
//  ProfilePermitView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/15.
//

import UIKit

class ProfilePermitView: BaseView {
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "내 번호 검색 허용"
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        return view
    }()
    
    let permitSwitch: UISwitch = {
        let view = UISwitch()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        [titleLabel, permitSwitch].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        permitSwitch.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.trailing.equalToSuperview().offset(-2)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(permitSwitch.snp.centerY)
            make.leading.equalToSuperview()
        }
    }
}
