//
//  MessageViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

import RxSwift
import FirebaseAuth

class MessageViewController: BaseViewController {
    
    let mainView = MessageView()
    let viewModel = MessageViewModel()
    
    let disposeBag = DisposeBag()
    
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
    func bindTo() {
        let input = MessageViewModel.Input(auth: mainView.authButton.rx.tap, valid: mainView.numberTextField.rx.text)
        
        let output = viewModel.transform(input: input)
        
        output.auth
            .withUnretained(self)
            .bind { vc, _ in
                vc.verificationCompare()
            }
            .disposed(by: disposeBag)
        
        output.valid
            .bind { value in
                if value.count > 6 {
                    self.mainView.numberTextField.text = value.validMessage(idx: 6)
                }
            }
            .disposed(by: disposeBag)
    }
}
