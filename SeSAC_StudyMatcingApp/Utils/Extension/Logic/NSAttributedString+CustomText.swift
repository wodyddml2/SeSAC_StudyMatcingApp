//
//  NSAtrributedString.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

extension NSAttributedString {
    static func introText(text: String, rangeText: String) -> NSAttributedString {
        let attributedStr = NSMutableAttributedString(string: text)
        let introText = text as NSString
        
        attributedStr.addAttribute(.foregroundColor, value: UIColor.sesacGreen, range: introText.range(of: rangeText))
        
        return attributedStr
    }
}
