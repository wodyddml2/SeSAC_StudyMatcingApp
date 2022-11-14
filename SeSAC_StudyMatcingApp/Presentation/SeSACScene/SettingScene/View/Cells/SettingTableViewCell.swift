//
//  ProfileTableCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/13.
//

import UIKit

class SettingTableViewCell: BaseTableViewCell {
    
    let iconImage: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    let settingLabel: UILabel = {
        let view = UILabel()
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureUI() {
        [iconImage, settingLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        iconImage.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(17)
            make.height.equalTo(24)
            make.width.equalTo(iconImage.snp.height)
        }
        
        settingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(iconImage.snp.trailing).offset(14)
        }
    }
}
