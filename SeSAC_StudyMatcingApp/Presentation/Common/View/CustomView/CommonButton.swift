//
//  CommonButton.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/14.
//

import UIKit

class CommonButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.gray4.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .white
        self.setTitleColor(.black, for: .normal)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        self.titleLabel?.font = UIFont.notoSans(size: 14, family: .Regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func normalStyle(width: CGFloat) {
        self.layer.borderWidth = width
        self.backgroundColor = .white
        self.setTitleColor(.black, for: .normal)
    }
    
    func selectedStyle() {
        self.layer.borderWidth = 0
        self.backgroundColor = .sesacGreen
        self.setTitleColor(.white, for: .normal)
    }
    
    func outlineStyle() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.sesacGreen.cgColor
        self.setTitleColor(.sesacGreen, for: .normal)
        self.backgroundColor = .white
    }
    
    func redButton() {
        self.layer.borderWidth = 0
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .errorRed
        self.titleLabel?.font = UIFont.notoSans(size: 14, family: .Medium)
    }
    
    func blueButton() {
        self.layer.borderWidth = 0
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .successBlue
        self.titleLabel?.font = UIFont.notoSans(size: 14, family: .Medium)
    }
    
    func blockButton() {
        self.layer.borderWidth = 0
        self.backgroundColor = .gray6
        self.setTitleColor(.gray3, for: .normal)
    }
  
}
