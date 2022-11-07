//
//  FirstViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

final class FirstViewController: BaseViewController {
    
    let mainView = OnboardingView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.introLabel.text =
            """
            위치 기반으로 빠르게
            주위 친구를 확인
            """
        
        mainView.onboardingImageView.image = .onboardingImage(num: 1)
        
        mainView.introLabel.attributedText = NSAttributedString.introText(text: mainView.introLabel.text!, rangeText: "위치 기반")
    }
}
