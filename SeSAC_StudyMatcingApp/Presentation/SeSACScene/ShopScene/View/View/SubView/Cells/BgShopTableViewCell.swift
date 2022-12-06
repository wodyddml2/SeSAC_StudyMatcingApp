//
//  BgShopTableViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/12/04.
//

import UIKit

import RxSwift

class BgShopTableViewCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()

    let sesacImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func configureUI() {
        [sesacImageView, sesacLabel, sesacPriceButton, sesacInfoLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
    
    override func setConstraints() {
        sesacImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(sesacImageView.snp.height)
        }
        
        sesacLabel.snp.makeConstraints { make in
            make.leading.equalTo(sesacImageView.snp.trailing).offset(12)
            make.top.equalTo(self.snp.centerY).multipliedBy(0.5)
        }
        
        sesacPriceButton.snp.makeConstraints { make in
            make.centerY.equalTo(sesacLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(52)
        }
        
        sesacInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacLabel.snp.bottom).offset(8)
            make.leading.equalTo(sesacLabel.snp.leading)
            make.trailing.bottom.lessThanOrEqualToSuperview()
        }
    }
}
