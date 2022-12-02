//
//  GenderViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import UIKit

import RxSwift

class GenderViewController: BaseViewController {
    
    let mainView = GenderView()
    let viewModel = GenderViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserManager.nickError {
            if UserManager.gender == Gender.man {
                mainView.manView.backgroundColor = .sesacWhiteGreen
            } else {
                mainView.womanView.backgroundColor = .sesacWhiteGreen
            }
            mainView.authButton.backgroundColor = .sesacGreen
        }
    }
}

extension GenderViewController {
    private func bindViewModel() {
        let input = GenderViewModel.Input(
            manButton: mainView.manView.genderButton.rx.tap,
            womanButton: mainView.womanView.genderButton.rx.tap,
            nextButton: mainView.authButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        bindButtonTapped(output: output)
        
    }
    
    private func bindButtonTapped(output: GenderViewModel.Output) {
        output.manButton
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.manView.backgroundColor = .sesacWhiteGreen
                vc.mainView.womanView.backgroundColor = .white
                vc.mainView.authButton.backgroundColor = .sesacGreen
            }
            .disposed(by: disposeBag)
        
        output.womanButton
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.manView.backgroundColor = .white
                vc.mainView.womanView.backgroundColor = .sesacWhiteGreen
                vc.mainView.authButton.backgroundColor = .sesacGreen
            }
            .disposed(by: disposeBag)
        
        
        
        output.nextButton
            .throttle(.seconds(3), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { vc, _ in
                if vc.mainView.authButton.backgroundColor == .sesacGreen {
                    UserManager.gender = vc.mainView.manView.backgroundColor == .sesacWhiteGreen ? Gender.man : Gender.woman
                    SeSACAPIService.shared.requestSeSACAPI(type: SESACLoginDTO.self,router: UserRouter.signUp) { result in
                        switch result {
                        case .success(_):
                            UserManager.signupStatus = true
                            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                            let sceneDelegate = windowScene?.delegate as? SceneDelegate
                            let vc = TabViewController()
                            sceneDelegate?.window?.rootViewController = vc
                            sceneDelegate?.window?.makeKeyAndVisible()
                        case .failure(let fail):
                            let error = fail as! SeSACError
                            switch error {
                            case .notNickname:
                                vc.notNicknameError(error: error.errorDescription ?? "닉네임 불가")
                            case .existingUsers:
                                vc.existingUsersError(error: error.errorDescription ?? "이미 가입된 회원")
                            default:
                                vc.mainView.makeToast(error.errorDescription, position: .center)
                            }
                        }
                    }
                } else {
                    vc.mainView.makeToast("성별을 선택해주세요.", position: .center)
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    private func notNicknameError(error: String) {
        UserManager.nickError = true
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]

        for viewController in viewControllers {
            if let rootVC = viewController as? NicknameViewController {
                navigationController?.popToViewController(rootVC, animated: true)
                rootVC.mainView.makeToast(error, position: .center)
            }
        }
    }
    
    private func existingUsersError(error: String) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]

        for viewController in viewControllers {
            if let rootVC = viewController as? NumberViewController {
                navigationController?.popToViewController(rootVC, animated: true)
                rootVC.mainView.makeToast(error, position: .center) // toast가 찌그러져서 뜸 ;;
            }
        }
    }
}
