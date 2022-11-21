//
//  WithdrawViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/16.
//

import UIKit

import FirebaseAuth
import RxSwift

class WithdrawViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    let mainView = PopupView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.titleText(title: "정말 탈퇴하시겠습니까?", subTitle: "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ")
        view.layer.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.5)
        bindTo()
    }
   
    
    func bindTo() {
        mainView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
        
        mainView.okButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.requestWithdraw()
            }
            .disposed(by: disposeBag)
    }
    
    func requestWithdraw() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else {return}
            if error != nil {
                print("error")
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                SeSACAPIService.shared.requestStatusSeSACAPI(router: Router.withdrawPost(query: UserManager.idToken)) { value in
                    switch StatusCode(rawValue: value) {
                    case .success, .noSignup:
                        UserManager.onboarding = false
                        let vc = OnboardingViewController()
                        sceneDelegate?.window?.rootViewController = vc
                        sceneDelegate?.window?.makeKeyAndVisible()
                    default:
                        self.dismiss(animated: false)
                        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                        viewController.view.makeToast("응 못나가~", position: .center)
                    }
                }
            }
        }
        
    }
    
  
}
