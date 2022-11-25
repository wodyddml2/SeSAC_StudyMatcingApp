//
//  ChatMenuImage.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/24.
//

import UIKit

enum ChatMenuImage: String {
    case cancel
    case siren
    case write
    
    var image: UIImage? {
        return UIImage(named: "\(self.rawValue)_chat")
    }
}
