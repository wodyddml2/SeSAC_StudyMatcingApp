//
//  SplashViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/11.
//

import UIKit

class SplashViewController: BaseViewController {
    
    let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "splash_logo")
        return view
    }()
    
    let textImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "splash_text")
        view.contentMode = .scaleAspectFit
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoImageView.alpha = 1
        self.textImageView.alpha = 1
        
        UIView.animate(withDuration: 0.4, delay: 1.5, options: .curveEaseOut, animations: {
            self.logoImageView.alpha = 0
            self.textImageView.alpha = 0
        }) { _ in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate

            if UserManager.onboarding {
                if UserManager.login == LoginStatusCode.success {
                    print("나중~")
                } else {
                    let vc = UINavigationController(rootViewController: NumberViewController())
                    sceneDelegate?.window?.rootViewController = vc
                }

            } else {
                let vc = OnboardingViewController()
                sceneDelegate?.window?.rootViewController = vc
            }

            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }
    
    override func configureUI() {
        [logoImageView, textImageView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.82)
            make.width.equalToSuperview().multipliedBy(0.58)
            make.height.equalTo(logoImageView.snp.width).multipliedBy(1.19)
        }
        
        textImageView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
            make.width.equalTo(logoImageView.snp.width).multipliedBy(1.34)
            make.height.equalTo(textImageView.snp.width).multipliedBy(0.35)
        }
    }

}
