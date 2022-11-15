//
//  PrifileWithdrawView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/15.
//

import UIKit

class ProfileWithdrawView: BaseView {
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "회원탈퇴"
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        return view
    }()
    
    let withdrawButton: UIButton = {
        let view = UIButton()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        [titleLabel, withdrawButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(10)
        }
        withdrawButton.snp.makeConstraints { make in
            make.edges.equalTo(titleLabel)
        }
    }
}
