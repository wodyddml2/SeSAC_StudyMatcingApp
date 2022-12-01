//
//  BaseViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

import FirebaseAuth

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureUI()
        setConstraints()
    }
    
    func configureUI() { }
    
    func setConstraints() { }
    
    func showSettingAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        
        [ok, cancel].forEach {
            alert.addAction($0)
        }
        
        self.present(alert, animated: true)
    }
    
    func sceneChange(viewController vc: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let nav = UINavigationController(rootViewController: vc)
        
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func navigationBackButton() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.setBackIndicatorImage(UIImage(named: "arrow"), transitionMaskImage: UIImage(named: "arrow"))
        navigationController?.navigationBar.scrollEdgeAppearance = navigationAppearance
        navigationController?.navigationBar.standardAppearance = navigationAppearance
        
    }
    
    func renwalGetIdToken(completion: @escaping () -> Void) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if error != nil {
                return
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                completion()
            }
        }
    }
}

