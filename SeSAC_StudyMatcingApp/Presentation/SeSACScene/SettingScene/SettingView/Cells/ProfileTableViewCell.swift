//
//  MyProfileTableViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/13.
//

import UIKit

class ProfileTableViewCell: BaseTableViewCell {
    
    let profileImage: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.width / 2
        view.layer.borderColor = UIColor.gray2.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let rightImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.right")
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray7
        return view
    }()
    
    let profileLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.notoSans(size: 16, family: .Regular)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureUI() {
        [profileImage, rightImage, profileLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(15)
            make.height.equalTo(48)
            make.width.equalTo(profileImage.snp.height)
        }
        
        profileLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(profileImage.snp.trailing).offset(13)
        }
        
        rightImage.snp.makeConstraints { make in
            make.trailing.equalTo(-22.5)
            make.centerY.equalTo(self)
            make.height.equalTo(24)
            make.width.equalTo(rightImage.snp.height)
        }
    }
}
