//
//  SeSACFindReviewTableViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/19.
//

import UIKit

class SeSACFindReviewTableViewCell: MyProfileReviewTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        reviewView.sesacStudyTitleLabel.text = "하고 싶은 스터디"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        super.configureUI()
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        reviewView.sesacStudyTitleLabel.snp.remakeConstraints { make in
            make.top.equalTo(reviewView.reviewStackView.snp.bottom).offset(24)
            make.leading.equalToSuperview()
        }

        reviewView.sesacStudyLabel.snp.remakeConstraints { make in
            make.top.equalTo(reviewView.sesacStudyTitleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    func reviewText(text: String, color: UIColor = .black, bool: Bool = true) {
        reviewView.sesacReviewLabel.text = text
        reviewView.sesacReviewLabel.textColor = color
        reviewView.sesacReviewButton.isHidden = bool
    }
    
    func setFindData(item: SeSACFind) {
        nicknameLabel.text = item.nickname
        if item.comment.isEmpty {
            reviewText(text: "첫 리뷰를 기다리는 중이에요", color: .gray5)
        } else if item.comment.count == 1 {
            reviewText(text: item.comment.last!)
        } else {
            reviewText(text: item.comment.last!, bool: false)
        }
        
        configureReputation(reputation: item.sesacTitle)
        
       
    }
    
    func wishStudyLabel(item: SeSACFind) -> String {
        var studyText = ""
        for study in item.studyList {
            if study == "" {
                studyText += ""
            } else if study == "anything" {
                studyText += "아무거나, "
            } else {
                studyText += "\(study), "
            }
        }
        if studyText.count > 2 {
            studyText.removeLast(2)
        }
        return studyText
    }
}
