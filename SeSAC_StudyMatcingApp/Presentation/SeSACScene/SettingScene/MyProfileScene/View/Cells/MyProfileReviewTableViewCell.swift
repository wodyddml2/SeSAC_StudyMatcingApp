//
//  ProfileReviewTableViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/14.
//

import UIKit

class MyProfileReviewTableViewCell: BaseTableViewCell {
    
    let nicknameLabel: UILabel = {
        let view = UILabel()
        view.text = "김아무개"
        return view
    }()
    
    let sesacReviewImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.down")
        view.tintColor = .gray7
        view.contentMode = .scaleAspectFit
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray2.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func configureUI() {
        [nicknameLabel, sesacReviewImageView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.centerY.equalTo(self)
        }
        sesacReviewImageView.snp.makeConstraints { make in
            make.trailing.equalTo(-18)
            make.centerY.equalTo(self)
            make.width.height.equalTo(16)
        }
    }
}
