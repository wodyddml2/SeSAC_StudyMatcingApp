//
//  ThirdViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

final class ThirdViewController: BaseViewController {
    
    let mainView = OnboardingView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.introLabel.text = "SeSAC Study"
        
        mainView.onboardingImageView.image = .onboardingImage(num: 3)
    }

    override func setConstraints() {
        mainView.introLabel.snp.updateConstraints { make in
            make.top.equalTo(135)
        }
    }
}
