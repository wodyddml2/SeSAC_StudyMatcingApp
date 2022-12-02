//
//  EmailViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import UIKit

import RxSwift

class EmailViewController: BaseViewController {
    
    let mainView = EmailView()
    let viewModel = EmailViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBackButton()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserManager.nickError {
            mainView.emailTextField.text = UserManager.email
        }
    }
    
}

extension EmailViewController {
    private func bindViewModel() {
        let input = EmailViewModel.Input(
            nextButton: mainView.authButton.rx.tap,
            valid: mainView.emailTextField.rx.text
        )
        let output = viewModel.transform(input: input)
        
        bindButtonTapped(output: output)
        bindValidText(output: output)
    }
    
    private func bindButtonTapped(output: EmailViewModel.Output) {
        output.nextButton
            .withUnretained(self)
            .bind { vc, _ in
                if vc.mainView.authButton.backgroundColor == .sesacGreen {
                    UserManager.email = vc.mainView.emailTextField.text!
                    vc.transition(GenderViewController(), transitionStyle: .push)
                } else {
                    vc.mainView.makeToast(Comment.Signup.emailValid, position: .center)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindValidText(output: EmailViewModel.Output) {
        output.valid
            .withUnretained(self)
            .bind { vc, value in
                vc.mainView.authButton.backgroundColor = value ? .sesacGreen : .gray6
            }
            .disposed(by: disposeBag)
    }
    
   
}
