//
//  UIView+Shadow.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/16.
//

import UIKit

extension UIView {
    func makeCornerStyle(width: CGFloat = 0,
                         color: CGColor? = nil,
                         radius: CGFloat = 1) {
        layer.borderWidth = width
        layer.borderColor = color
        layer.cornerRadius = radius
    }

    func makeShadow(color: CGColor = UIColor.black.cgColor,
                    radius: CGFloat,
                    offset: CGSize,
                    opacity: Float) {
        layer.shadowColor = color
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        clipsToBounds = false
    }
}

