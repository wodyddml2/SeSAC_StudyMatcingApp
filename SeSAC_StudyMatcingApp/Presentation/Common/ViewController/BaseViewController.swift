//
//  BaseViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureUI()
        setConstraints()
    }
    
    func configureUI() { }
    
    func setConstraints() { }
    
//    func showAlert(text: String) {
//        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
//
//        let ok = UIAlertAction(title: "확인", style: .default)
//
//        alert.addAction(ok)
//
//        present(alert, animated: true)
//    }
    
    func sceneChange(viewController vc: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let nav = UINavigationController(rootViewController: vc)
        
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func navigationBackButton() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arrow")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow")
    }
}
