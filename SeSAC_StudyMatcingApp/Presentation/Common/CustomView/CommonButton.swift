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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func normalStyle() {
        self.layer.borderWidth = 1
        self.backgroundColor = .white
        self.setTitleColor(.black, for: .normal)
    }
    
    func selectedStyle() {
        self.layer.borderWidth = 0
        self.backgroundColor = .sesacGreen
        self.setTitleColor(.white, for: .normal)
    }
}