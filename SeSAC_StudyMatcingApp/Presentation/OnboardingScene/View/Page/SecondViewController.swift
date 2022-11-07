//
//  SecondViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

final class SecondViewController: BaseViewController {
    
    let mainView = OnboardingView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.introLabel.text =
            """
            스터디를 원하는 친구를
            찾을 수 있어요
            """
        
        mainView.onboardingImageView.image = .onboardingImage(num: 2)
        
        mainView.introLabel.attributedText = NSAttributedString.introText(text: mainView.introLabel.text!, rangeText: "스터디를 원하는 친구")
    }
}
