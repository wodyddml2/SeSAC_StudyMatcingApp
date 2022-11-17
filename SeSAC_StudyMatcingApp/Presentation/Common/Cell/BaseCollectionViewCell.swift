//
//  BaseCollectionViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/16.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setConstraints()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() { }
    
    func setConstraints() { }
    
    func outlineBorder() {
        layer.borderColor = UIColor.sesacGreen.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
    }
    
}
