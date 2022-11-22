//
//  SeSACFindTableViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/19.
//

import UIKit

class SeSACFindImageTableViewCell: MyProfileImageTableViewCell {
    
    let multiButton: CommonButton = {
        let view = CommonButton()
        view.redButton()
        view.setTitle("요청하기", for: .normal)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    
    override func configureUI() {
        super.configureUI()
        contentView.addSubview(multiButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        multiButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(sesacBackgroundImageView).inset(12)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
    }
}
