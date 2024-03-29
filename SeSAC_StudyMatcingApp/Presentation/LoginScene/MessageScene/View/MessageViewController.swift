//
//  MessageViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import FirebaseAuth

class MessageViewController: BaseViewController {
    
    let mainView = MessageView()
    let viewModel = MessageViewModel()
    
    let firebaseAPI = FirebaseAPIService()
    
    var disposeBag = DisposeBag()
    
    var timerDisposable: Disposable?
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBackButton()
    }
    
    override func configureUI() {
        bindViewModel()
        
    }
}

extension MessageViewController {
    func setTimer(with timer: Observable<Int>) {
        timerDisposable?.dispose()
        timerDisposable = timer
            .withUnretained(self)
            .subscribe(onNext: { vc, value in
                if value <= 50 {
                    vc.mainView.timerLabel.text = value == 0 ? "01:00" : "00:\(60 - value)"
                } else if value <= 60 {
                    vc.mainView.timerLabel.text = "00:0\(60 - value)"
                } else {
                    vc.timerDisposable?.dispose()
                    
                }
            }, onDisposed: {
                UserManager.authVerificationID = ""
            })
    }
}

extension MessageViewController {
    
    private func bindViewModel() {
        let input = MessageViewModel.Input(
            auth: mainView.authButton.rx.tap,
            resend: mainView.resendButton.rx.tap,
            valid: mainView.numberTextField.rx.text,
            beginEdit: mainView.numberTextField.rx.controlEvent([.editingDidBegin]),
            endEdit: mainView.numberTextField.rx.controlEvent([.editingDidEnd])
        )
        
        let output = viewModel.transform(input: input)
        
        setTimer(with: output.timer)
        
        mainView.rx.tapGesture()
            .when(.recognized)
            .subscribe { _ in
                self.mainView.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        bindButtonTapped(output: output)
        bindValidText(output: output)
        bindTextFieldEdit(output: output)
        
    }
    
    private func bindButtonTapped(output: MessageViewModel.Output) {
 
        output.auth
            .withUnretained(self)
            .bind { vc, _ in
                vc.firebaseAPI.requestVerificationCompare(text: vc.mainView.numberTextField.text!) { result in
                    switch result {
                    case .success(let success):
                        success.user.getIDTokenForcingRefresh(true) { idToken, error in
                            if error != nil {
                                vc.view.makeToast("에러가 발생했습니다.")
                                return
                            }
                            
                            if let idToken = idToken {
                                SeSACAPIService.shared.requestSeSACAPI(type: SESACLoginDTO.self ,router: UserRouter.login(query: idToken)) { result in
                                    switch result {
                                    case .success(_):
                                        UserManager.signupStatus = true
                                        UserManager.idToken = idToken
                                        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                                        let sceneDelegate = windowScene?.delegate as? SceneDelegate
                                        let vc = TabViewController()
                                        sceneDelegate?.window?.rootViewController = vc
                                        sceneDelegate?.window?.makeKeyAndVisible()
                                    case .failure(let fail):
                                        let error = fail as! SeSACError
                                        if error == SeSACError.noSignup {
                                            UserManager.idToken = idToken
                                            UserManager.signupStatus = false
                                            UserManager.nickError = false
                                            
                                            vc.transition(NicknameViewController(), transitionStyle: .push)
                                        } else {
                                            vc.mainView.makeToast(error.errorDescription!, position: .center)
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                    case .failure(let fail):
                        vc.mainView.makeToast(fail.errorDescription!, position: .center)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.resend
            .withUnretained(self)
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .bind { vc, _ in
                vc.firebaseAPI.requestAuth(phoneNumber: UserManager.phoneNumber) { result in
                    vc.mainView.makeToast(Comment.Auth.resend.rawValue, position: .center)
                    switch result {
                    case .success(let success):
                        UserManager.authVerificationID = success
                        vc.setTimer(with: output.timer)
                    case .failure(let fail):
                        vc.mainView.makeToast(fail.errorDescription!, position: .center)
                    }
                }
                
                vc.mainView.numberTextField.text = nil

            }
            .disposed(by: disposeBag)
    }
    
    private func bindValidText(output: MessageViewModel.Output) {
        output.valid
            .bind { value in
                if value.count >= 6 {
                    self.mainView.numberTextField.text = value.validMessage(idx: 5)
                    self.mainView.authButton.backgroundColor = .sesacGreen
                } else {
                    self.mainView.authButton.backgroundColor = .gray6
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindTextFieldEdit(output: MessageViewModel.Output) {
        output.beginEdit
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.numberView.backgroundColor = .black
            }
            .disposed(by: disposeBag)
        
        output.endEdit
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.numberView.backgroundColor = .gray3
            }
            .disposed(by: disposeBag)
        
    }

}
