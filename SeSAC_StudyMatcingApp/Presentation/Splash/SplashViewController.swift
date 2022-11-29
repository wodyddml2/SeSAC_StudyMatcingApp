//
//  SplashViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/11.
//

import UIKit

import FirebaseAuth

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
        
        splashAnimation()
    }
    
    private func splashAnimation() {
        self.logoImageView.alpha = 1
        self.textImageView.alpha = 1
        
        UIView.animate(withDuration: 0.4, delay: 1.5, options: .curveEaseOut, animations: {
            self.logoImageView.alpha = 0
            self.textImageView.alpha = 0
        }) { [weak self] _ in
            guard let self = self else {return}
            self.requestSeSAC()
        }
    }
    
    private func requestSeSAC() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        if UserManager.onboarding {
            SeSACAPIService.shared.requestSeSACAPI(type: SESACLoginDTO.self ,router: Router.loginGet(query: UserManager.idToken)) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let success):
                    print(UserManager.idToken)
                    UserManager.sesacImage = success.sesac
                    UserManager.myUID = success.uid
                    let vc = TabViewController()
                    sceneDelegate?.window?.rootViewController = vc
                case .failure(let fail):
                    let error = fail as! SeSACError
                    switch error {
                    case .firebaseTokenError:
                        self.renewalRequest()
                    case .noSignup:
                        UserManager.signupStatus = false
                        let vc = UINavigationController(rootViewController: NumberViewController())
                        sceneDelegate?.window?.rootViewController = vc
                    default:
                        print(error.rawValue)
                        UserManager.signupStatus = true
                        let vc = UINavigationController(rootViewController: NumberViewController())
                        sceneDelegate?.window?.rootViewController = vc
                    }
                }
            }
        } else {
            let vc = OnboardingViewController()
            sceneDelegate?.window?.rootViewController = vc
        }
        
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    private func renewalRequest() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else {return}
            if error != nil {
                self.view.makeToast("에러가 발생했습니다.")
                return
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                
                SeSACAPIService.shared.requestSeSACAPI(type: SESACLoginDTO.self,router: Router.loginGet(query: idToken)) { result in
                    switch result {
                    case .success(let success):
                        UserManager.sesacImage = success.sesac
                        let vc = TabViewController()
                        sceneDelegate?.window?.rootViewController = vc
                    case .failure(let fail):
                        let error = fail as! SeSACError
                        switch error {
                        case .noSignup:
                            UserManager.signupStatus = false
                            let vc = UINavigationController(rootViewController: NumberViewController())
                            sceneDelegate?.window?.rootViewController = vc
                        default:
                            UserManager.signupStatus = true
                            let vc = UINavigationController(rootViewController: NumberViewController())
                            sceneDelegate?.window?.rootViewController = vc
                        }
                    }
                }
            }
        }
        sceneDelegate?.window?.makeKeyAndVisible()
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
