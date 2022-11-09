//
//  NicknameViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import UIKit

import RxSwift

final class NicknameViewController: BaseViewController {
    
    let mainView = NicknameView()
    let viewModel = NicknameViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBackButton()
        
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserManager.login = 0
    }

}

extension NicknameViewController {
    
    private func bindViewModel() {
        let input = NicknameViewModel.Input(
            auth: mainView.authButton.rx.tap,
            valid: mainView.nicknameTextField.rx.text,
            beginEdit: mainView.nicknameTextField.rx.controlEvent([.editingDidBegin]),
            endEdit: mainView.nicknameTextField.rx.controlEvent([.editingDidEnd])
        )
        
        let output = viewModel.transform(input: input)
   
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
    
    func nameFormatter(text: String) -> Bool {
        let trimString = text.trimmingCharacters(in: [" "])
        return trimString.count == 0 ? false : true
    }
    
    private func bindButtonTapped(output: NicknameViewModel.Output) {
        output.auth
            .withUnretained(self)
            .bind { vc, _ in
                guard let nicknameText = vc.mainView.nicknameTextField.text else {return}
                if vc.mainView.authButton.backgroundColor == .sesacGreen && vc.nameFormatter(text: nicknameText) {
                    UserManager.nickname = nicknameText
                    vc.transition(BirthViewController(), transitionStyle: .push)
                } else {
                    vc.mainView.makeToast(SignupCommet.nicknameValid, position: .center)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindValidText(output: NicknameViewModel.Output) {
        output.valid
            .bind { value in
                switch true {
                case value.count == 0:
                    self.mainView.authButton.backgroundColor = .gray6
                case value.count > 0 && value.count < 10:
                    self.mainView.authButton.backgroundColor = .sesacGreen
                case value.count >= 10:
                    self.mainView.nicknameTextField.text = value.validMessage(idx: 9)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    private func bindTextFieldEdit(output: NicknameViewModel.Output) {
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
