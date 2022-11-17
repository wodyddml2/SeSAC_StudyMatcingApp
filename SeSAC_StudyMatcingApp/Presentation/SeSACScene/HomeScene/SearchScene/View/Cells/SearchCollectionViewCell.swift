//
//  SearchCollectionViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/16.
//

import UIKit

class SearchCollectionViewCell: BaseCollectionViewCell {
    
    let studyButton: CommonButton = {
        let view = CommonButton()
        view.outlineStyle()
        view.setTitle("Ss", for: .normal)
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        view.configuration = config
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        self.addSubview(studyButton)
    }
    
    override func setConstraints() {
        studyButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
