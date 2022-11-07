//
//  UIViewController+Transition.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

extension UIViewController {
    enum TransitionStyle {
        case presentFull
        case presentOverFull
        case push
    }
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle) {
        let vc = viewController
        
        switch transitionStyle {
        case .presentFull:
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        case .presentOverFull:
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        case .push:
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
