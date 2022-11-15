//
//  ProfileAgeView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/15.
//

import UIKit

import MultiSlider

class ProfileAgeView: BaseView {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "상대방 연령대"
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        return view
    }()
    
    let ageLabel: UILabel = {
        let view = UILabel()
        view.text = "18-65"
        view.textColor = .sesacGreen
        view.font = UIFont.notoSans(size: 14, family: .Medium)
        return view
    }()
    
    let ageSlider: MultiSlider = {
        let view = MultiSlider()
        view.orientation = .horizontal
        view.thumbCount = 2
        view.minimumValue = 18
        view.maximumValue = 65
        view.tintColor = .sesacGreen
        view.thumbImage = UIImage(named: "slider")!
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        [titleLabel, ageLabel, ageSlider].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.leading.equalToSuperview()
        }
        
        ageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
        
        ageSlider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(14)
        }
    }
}
