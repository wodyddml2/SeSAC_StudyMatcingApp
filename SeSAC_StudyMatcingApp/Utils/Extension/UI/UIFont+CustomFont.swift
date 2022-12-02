//
//  UIFont+CustomFont.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

extension UIFont {
    enum Family: String {
        case Regular
        case Medium
    }
    
    static func notoSans(size: CGFloat = 14, family: Family = .Regular) -> UIFont {
        return UIFont(name: "NotoSansKR-\(family)", size: size) ?? .systemFont(ofSize: size)
    }
}
