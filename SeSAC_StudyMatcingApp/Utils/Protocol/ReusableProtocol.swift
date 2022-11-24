//
//  ReusableProtocol.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/13.
//

import UIKit

protocol ReusableProtocol {
    static var reusableIdentifier: String { get }
}

extension UITableViewCell: ReusableProtocol {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableProtocol {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView: ReusableProtocol {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
