//
//  SeSACShopCollectionViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/12/04.
//

import UIKit

class SeSACShopCollectionViewCell: BaseCollectionViewCell {
    let sesacImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.gray2.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let sesacLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.notoSans(size: 16, family: .Regular)
        return view
    }()
    
    let sesacPriceButton: CommonButton = {
        let view = CommonButton()
        view.priceOwnedButton()
        return view
    }()
    
    let sesacInfoLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        view.numberOfLines = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        [sesacImageView, sesacLabel, sesacPriceButton, sesacInfoLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        sesacImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(sesacImageView.snp.width)
        }
        
        sesacLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        sesacPriceButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(9)
            make.centerY.equalTo(sesacLabel)
            make.height.equalTo(20)
            make.width.equalTo(52)
        }
        
        sesacInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.bottom.lessThanOrEqualToSuperview()
        }
    }
}
