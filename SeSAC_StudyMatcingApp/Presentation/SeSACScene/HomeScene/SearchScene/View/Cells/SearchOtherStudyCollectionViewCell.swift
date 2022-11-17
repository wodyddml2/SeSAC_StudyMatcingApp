//
//  SearchOtherStudyCollectionViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/18.
//

import UIKit

class SearchOtherStudyCollectionViewCell: BaseCollectionViewCell {
    
    let studyLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        self.addSubview(studyLabel)
    }
    
    override func setConstraints() {

        studyLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
