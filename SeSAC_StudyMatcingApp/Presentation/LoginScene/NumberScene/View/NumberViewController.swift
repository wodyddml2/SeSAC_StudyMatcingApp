//
//  LoginViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

import RxSwift
import RxGesture
import Toast

final class NumberViewController: BaseViewController {
    
    let mainView = NumberView()
    let viewModel = NumberViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        navigationItem.backButtonTitle = ""
        if UserManager.signupStatus == false {
            transition(NicknameViewController(), transitionStyle: .noAnimatedPush)
        }
    }
}

extension NumberViewController {
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
    
    private func formattingNumber() -> String {
        guard var text = mainView.numberTextField.text else {return ""}
        text.remove(at: text.startIndex)
        
        let formater = "+82 " + text
        
        return formater
    }
    
    private func requestFirebase() {
        FirebaseAPIService.shared.requestAuth(phoneNumber: formattingNumber()) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                UserManager.authVerificationID = success
                UserManager.phoneNumber = self.formattingNumber()
                
                self.transition(MessageViewController(), transitionStyle: .push)
            case .failure(let fail):
                self.mainView.makeToast(fail.errorDescription!, position: .center)
            }
        }
    }

}

extension NumberViewController {
    
    private func bindViewModel() {
        let input = NumberViewModel.Input(
            numberText: mainView.numberTextField.rx.text,
            beginEdit: mainView.numberTextField.rx.controlEvent([.editingDidBegin]),
            endEdit: mainView.numberTextField.rx.controlEvent([.editingDidEnd]),
            auth: mainView.authButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.auth
            .withUnretained(self)
            .bind { vc, _ in
                if vc.mainView.authButton.backgroundColor == .sesacGreen {
                    self.mainView.makeToast(AuthComent.phoneAuth.rawValue, duration: 5, position: .center)
                    
                    vc.requestFirebase()
                } else {
                    vc.mainView.makeToast(AuthComent.invalidNumber.rawValue, position: .center)
                }
            }
            .disposed(by: disposeBag)
        
        mainView.rx.tapGesture()
            .when(.recognized)
            .subscribe { _ in
                self.mainView.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        bindValidText(output: output)
        bindTextFieldEdit(output: output)
    }
    
    private func bindValidText(output: NumberViewModel.Output) {
        output.numberText
            .withUnretained(self)
            .bind { vc, value in
                if value.count <= 12 {
                    vc.mainView.numberTextField.text = vc.formattingHyphen(with: "XXX-XXX-XXXX", phone: value)
                } else {
                    vc.mainView.numberTextField.text = vc.formattingHyphen(with: "XXX-XXXX-XXXX", phone: value)
                }
            }
            .disposed(by: disposeBag)
        
        output.numberValid
            .withUnretained(self)
            .bind(onNext: { vc, bool in
                vc.mainView.authButton.backgroundColor = bool == true ? .sesacGreen : .gray6
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTextFieldEdit(output: NumberViewModel.Output) {
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
