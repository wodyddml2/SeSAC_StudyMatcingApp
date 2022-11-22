//
//  ReviewView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/15.
//

import UIKit

class ReviewView: BaseView {
    
    let sesacTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "새싹 타이틀"
        view.font = UIFont.notoSans(size: 12, family: .Regular)
        return view
    }()
    
    let reviewStackView: ReviewStackView = {
        let view = ReviewStackView()
        return view
    }()
    
    let sesacReviewTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "새싹 리뷰"
        view.font = UIFont.notoSans(size: 12, family: .Regular)
        return view
    }()
    
    let sesacReviewButton: UIButton = {
        let view = UIButton()
        view.isHidden = true
        view.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        view.tintColor = .gray7
        return view
    }()
    
    let sesacReviewLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        [sesacTitleLabel,reviewStackView, sesacReviewTitleLabel, sesacReviewButton, sesacReviewLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        sesacTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        reviewStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(sesacTitleLabel.snp.bottom).offset(16)
        }
        
        sesacReviewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewStackView.snp.bottom).offset(24)
            make.leading.equalToSuperview()
        }
        
        sesacReviewButton.snp.makeConstraints { make in
            make.top.equalTo(reviewStackView.snp.bottom).offset(24)
            make.bottom.equalTo(sesacReviewLabel.snp.top).offset(-16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        sesacReviewLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacReviewTitleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}
