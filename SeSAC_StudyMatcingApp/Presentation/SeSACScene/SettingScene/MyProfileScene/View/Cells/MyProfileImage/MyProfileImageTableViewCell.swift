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
        view.layer.cornerRadius = 8
        view.contentMode = .scaleToFill
        return view
    }()
    
    let sesacImageView: UIImageView = {
        let view = UIImageView()
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
            make.bottom.equalTo(8)
            make.centerX.equalToSuperview().offset(-5)
            make.width.equalTo(sesacImageView.snp.height)
        }
    }
}
