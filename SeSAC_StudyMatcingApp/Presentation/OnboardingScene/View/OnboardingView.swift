//
//  OnboardingView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

import SnapKit

final class OnboardingView: BaseView {
    
    let onboardingImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let introLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.textAlignment = .center
        view.font = UIFont.notoSans(size: 24, family: .Medium)
        return view
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [onboardingImageView, introLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        introLabel.snp.makeConstraints { make in
            make.top.equalTo(116)
            make.centerX.equalTo(self)
        }
 
        onboardingImageView.snp.makeConstraints { make in
            make.bottom.equalTo(-204)
            make.trailing.equalTo(-3)
            make.leading.equalTo(3)
            make.height.equalTo(onboardingImageView.snp.width)
            
        }
    }
}
