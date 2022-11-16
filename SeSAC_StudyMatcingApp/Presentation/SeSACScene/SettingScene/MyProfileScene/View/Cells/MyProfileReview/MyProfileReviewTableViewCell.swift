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
        return view
    }()
    
    let sesacReviewImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.down")
        view.tintColor = .gray7
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let reviewView: ReviewView = {
        let view = ReviewView()
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
        [nicknameLabel, sesacReviewImageView, reviewView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        nicknameLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.leading.equalTo(16)
            make.top.equalTo(16)
        }
        sesacReviewImageView.snp.makeConstraints { make in
            make.trailing.equalTo(-18)
            make.centerY.equalTo(nicknameLabel.snp.centerY)
            make.width.height.equalTo(16)
        }

        reviewView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(66)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    
    }
}

extension MyProfileReviewTableViewCell {
    func configureReputation(reputation: [Int]) {
        let review = reviewView.reviewStackView
        [review.mannerButton, review.promiseButton, review.fastButton, review.kindButton, review.skillButton, review.beneficialButton].forEach {
            setReputation(reputation: reputation, sender: $0)
        }
    }
    
    func setReputation(reputation: [Int], sender : CommonButton) {
        if reputation[sender.tag] > 0 {
            sender.selectedStyle()
        } else {
            sender.normalStyle()
        }
    }
    
    func setData(item: SeSACProfileGet) {
        nicknameLabel.text = item.nickname
        if item.comment.isEmpty {
            reviewView.sesacReviewLabel.text = "첫 리뷰를 기다리는 중이에요"
            reviewView.sesacReviewLabel.textColor = .gray5
        } else if item.comment.count == 1 {
            reviewView.sesacReviewLabel.text = item.comment.first
        } else {
            reviewView.sesacReviewLabel.text = item.comment.first
            reviewView.sesacReviewImageView.isHidden = false
            reviewView.sesacReviewButton.isHidden = false
        }
        
        configureReputation(reputation: item.sesacTitle)
    }
}
