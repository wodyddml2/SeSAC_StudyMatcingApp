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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func setConstraints() {
        super.setConstraints()
    }

    
    func setFindData(item: SeSACFind) {
        nicknameLabel.text = item.nickname
        if item.comment.isEmpty {
            reviewView.sesacReviewLabel.text = "첫 리뷰를 기다리는 중이에요"
            reviewView.sesacReviewLabel.textColor = .gray5
        } else if item.comment.count == 1 {
            reviewView.sesacReviewLabel.text = item.comment.last
        } else {
            reviewView.sesacReviewLabel.text = item.comment.last
            reviewView.sesacReviewButton.isHidden = false
        }
        
        configureReputation(reputation: item.sesacTitle)
    }
}
