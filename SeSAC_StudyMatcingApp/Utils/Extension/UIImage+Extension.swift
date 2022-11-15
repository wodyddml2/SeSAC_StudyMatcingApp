//
//  UIImageView+OnboardingImage.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

extension UIImage {
    
    static func onboardingImage(num: Int) -> UIImage {
        return UIImage(named: "onboarding_img\(num)") ?? UIImage(systemName: "person")!
    }
    
    static func sesacBackgroundImage(num: Int) -> UIImage {
        return UIImage(named: "background_\(num)") ?? UIImage(systemName: "person")!
    }
    
    static func sesacImage(num: Int) -> UIImage {
        return UIImage(named: "sesac_\(num)") ?? UIImage(systemName: "person")!
    }
    
    static func commonImage(name: String) -> UIImage {
        return UIImage(named: name) ?? UIImage(systemName: "person")!
    }
}
