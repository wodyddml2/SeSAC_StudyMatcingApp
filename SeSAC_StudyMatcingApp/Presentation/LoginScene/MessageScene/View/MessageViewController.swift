//
//  MessageViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

import RxSwift
import RxCocoa
import FirebaseAuth

class MessageViewController: BaseViewController {
    
    let mainView = MessageView()
    let viewModel = MessageViewModel()
    
    var disposeBag = DisposeBag()
    var timerDisposable: Disposable?
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arrow")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow")
        mainView.authButton.isEnabled = true
    }
    
    override func configureUI() {
        bindTo()
    }
    
    //    func ss() {
    //        let driver = Driver<Int>.interval(.seconds(1))
    //            .map { _ in
    //                return 1
    //            }
    //
    //        driver.asObservable()
    //            .subscribe { value in
    //                <#code#>
    //            }
    //    }
    //
    func verificationCompare() {
        let verificationCode = mainView.numberTextField.text!
        let verificationID = UserManager.authVerificationID
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                print("LogIn Failed...")
            }
            print("LogIn Success!!")
            print("\(authResult!.user)")
        }
    }
    
}

extension MessageViewController {
    
    func setTimer(with timer: Observable<Int>) {
        timerDisposable?.dispose()
        timerDisposable = timer
            .subscribe { value in
                if value <= 50 {
                    self.mainView.timerLabel.text = value == 0 ? "01:00" : "00:\(60 - value)"
                } else if value <= 60 {
                    self.mainView.timerLabel.text = "00:0\(60 - value)"
                } else {
                    self.timerDisposable?.dispose()
                }
            }
    }
    
    func bindTo() {
        let input = MessageViewModel.Input(auth: mainView.authButton.rx.tap, valid: mainView.numberTextField.rx.text)
        
        let output = viewModel.transform(input: input)
        
        setTimer(with: output.timer)
        
        mainView.resendButton.rx.tap
            .bind { _ in
                
                self.setTimer(with: output.timer)
            }
            .disposed(by: disposeBag)
        
        output.auth
            .withUnretained(self)
            .bind { vc, _ in
                vc.verificationCompare()
            }
            .disposed(by: disposeBag)
        
        output.valid
            .bind { value in
                if value.count > 6 {
                    self.mainView.numberTextField.text = value.validMessage(idx: 5)
                }
            }
            .disposed(by: disposeBag)
    }
}
