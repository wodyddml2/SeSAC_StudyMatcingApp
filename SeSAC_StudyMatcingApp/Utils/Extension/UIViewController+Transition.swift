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
        case noAnimatedPush
    }
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle) {
        let vc = viewController
        
        switch transitionStyle {
        case .presentFull:
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        case .presentOverFull:
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        case .push:
            navigationController?.pushViewController(vc, animated: true)
        case .noAnimatedPush:
            navigationController?.pushViewController(vc, animated: false)
        }
    }
}

extension UIViewController {
    
    var topViewController: UIViewController? {
        return self.topViewController(currentViewController: self)
    }
    
    // 최상위 뷰컨트롤러를 판단하는 메서드
    func topViewController(currentViewController: UIViewController) -> UIViewController {
        if let tabBarController = currentViewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            
            return self.topViewController(currentViewController: selectedViewController)
            
        } else if let navigationController = currentViewController as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
            
            return self.topViewController(currentViewController: visibleViewController)
            
        } else if let presentedViewController = currentViewController.presentedViewController {
            
            return self.topViewController(currentViewController: presentedViewController)
            
        } else {
            return currentViewController
        }
    }
    
    func navigationPopToViewController<T: UIViewController>(_ vc: T) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]

        for viewController in viewControllers {
            if let rootVC = viewController as? T {
                self.navigationController?.popToViewController(rootVC, animated: true)
            }
        }
    }
}

extension UIViewController {
    func tabBarAndNaviHidden(hidden: Bool) {
        navigationController?.navigationBar.isHidden = !hidden
        tabBarController?.tabBar.isHidden = hidden
    }
    
    func navigationBarCommon(title: String) {
        navigationItem.backButtonTitle = ""
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = .black
    
        let navigationAppearance = UINavigationBarAppearance()
        navigationController?.navigationBar.scrollEdgeAppearance = navigationAppearance
        navigationController?.navigationBar.standardAppearance = navigationAppearance
    }
}
