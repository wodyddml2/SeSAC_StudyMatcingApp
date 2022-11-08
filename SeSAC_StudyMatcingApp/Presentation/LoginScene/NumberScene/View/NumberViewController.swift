//
//  LoginViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

import RxSwift
import RxGesture
import FirebaseAuth

final class NumberViewController: BaseViewController {
    
    let mainView = NumberView()
    let viewModel = NumberViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindTo()
        navigationItem.backButtonTitle = ""
    }
    
    private func formattingHyphen(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex

        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])

                index = numbers.index(after: index)

            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    
}

extension NumberViewController {
    private func bindTo() {
        
        let input = NumberViewModel.Input(
            numberText: mainView.numberTextField.rx.text,
            beginEdit: mainView.numberTextField.rx.controlEvent([.editingDidBegin]),
            endEdit: mainView.numberTextField.rx.controlEvent([.editingDidEnd]),
            auth: mainView.authButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.numberText
            .withUnretained(self)
            .bind { vc, value in
                
                if value.validPhone(idx: 2) == "0" {
                    vc.mainView.numberTextField.text = vc.formattingHyphen(with: "XXX-XXXX-XXXX", phone: value)
                } else {
                    vc.mainView.numberTextField.text = vc.formattingHyphen(with: "XXX-XXX-XXXX", phone: value)
                }
                
            }
            .disposed(by: disposeBag)
        
        output.numberValid
            .withUnretained(self)
            .bind(onNext: { vc, bool in
                vc.mainView.authButton.isEnabled = bool
                vc.mainView.authButton.backgroundColor = bool == true ? .sesacGreen : .gray6
            })
            .disposed(by: disposeBag)
        
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
        
        
        mainView.rx.tapGesture()
            .when(.recognized)
            .subscribe { _ in
                self.mainView.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        output.auth
            .withUnretained(self)
            .bind { vc, _ in
                vc.requestAuth(phoneNumber: vc.formattingNumber())
                
            }
            .disposed(by: disposeBag)
            
    }
    
    func requestAuth(phoneNumber: String) {
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in

              if let error = error {
                  print(error)
                return
              }
              guard let verificationID  = verificationID else {return}
              
              UserManager.authVerificationID = verificationID
      
          }
        Auth.auth().languageCode = "kr"
        transition(MessageViewController(), transitionStyle: .push)
    }
    
    func formattingNumber() -> String {
        guard var text = mainView.numberTextField.text else {return ""}
        text.remove(at: text.startIndex)
        
        let formater = "+82 " + text
        
        return formater
    }
}