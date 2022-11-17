//
//  SearchCollectionViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/16.
//

import UIKit

class SearchCollectionViewCell: BaseCollectionViewCell {
    
    let studyLabel: UILabel = {
        let view = UILabel()
        view.textColor = .sesacGreen
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        return view
    }()
    
    let cancelImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "xmark")
        view.contentMode = .scaleAspectFit
        view.tintColor = .sesacGreen
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        [studyLabel, cancelImage].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {

        studyLabel.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(cancelImage.snp.leading).offset(-4)
        }
        
        cancelImage.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-16)
        }
    }
}
