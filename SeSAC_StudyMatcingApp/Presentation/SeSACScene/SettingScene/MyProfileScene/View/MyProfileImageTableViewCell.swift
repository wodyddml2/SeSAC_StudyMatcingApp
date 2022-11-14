//
//  MyProfileImageTableViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/14.
//

import UIKit

class MyProfileImageTableViewCell: BaseTableViewCell {
    let sesacBackgroundImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view .layer.cornerRadius = 8
        view.backgroundColor = .sesacGreen
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let sesacImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .sesacWhiteGreen
        view.contentMode = .scaleAspectFit
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    
    override func configureUI() {
        self.addSubview(sesacBackgroundImageView)
        sesacBackgroundImageView.addSubview(sesacImageView)
    }
    
    override func setConstraints() {
        sesacBackgroundImageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(16)
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.bottom.equalTo(self)
            make.leading.equalTo(sesacBackgroundImageView.snp.leading).offset(75)
            make.height.equalTo(sesacImageView.snp.width)
        }
    }
}
