//
//  GenderButtonView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import UIKit

class GenderButtonView: BaseView {
    let genderImage: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    let genderLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.notoSans(size: 16, family: .Regular)
        view.textAlignment = .center
        return view
    }()
    
    let genderButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 166, height: 120))
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray3.cgColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
    }
    
    override func configureUI() {
        [genderImage, genderLabel, genderButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        genderImage.snp.makeConstraints { make in
            make.bottom.equalTo(genderLabel.snp.top).offset(-4)
            make.centerX.equalTo(self)
            make.top.equalTo(4)
            make.width.equalTo(genderImage.snp.height)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-14)
            make.centerX.equalTo(self)
        }
        
        genderButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
