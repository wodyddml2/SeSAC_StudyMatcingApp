//
//  BirthViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import UIKit

import RxSwift

final class BirthViewController: BaseViewController {
    
    let mainView = BirthView()
    let viewModel = BirthViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBackButton()
        
        bindViewModel()
        
    }
//
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserManager.nickError {
            guard let birth = UserManager.birth else {return}
            mainView.datePicker.date = birth
            mainView.authButton.backgroundColor = .sesacGreen
            datePickerToText()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.yearView.textField.becomeFirstResponder()
    }

    func datePickerToText() {
        let date = mainView.datePicker.date
        
        mainView.yearView.textField.text = viewModel.datePickerFormat(dateFormat: "yyyy", date: date)
        mainView.monthView.textField.text = viewModel.datePickerFormat(dateFormat: "M", date: date)
        mainView.dayView.textField.text = viewModel.datePickerFormat(dateFormat: "d", date: date)
    }
}

extension BirthViewController {
    func bindViewModel() {
        
        let input = BirthViewModel.Input(
            nextButton: mainView.authButton.rx.tap,
            datePicker: mainView.datePicker.rx.controlEvent(.valueChanged)
        )
        
        let output = viewModel.transform(input: input)
        
        output.datePicker
            .withUnretained(self)
            .bind { vc, _ in
                vc.datePickerToText()
                vc.mainView.authButton.backgroundColor = .sesacGreen
            }
            .disposed(by: disposeBag)
        
        output.nextButton
            .withUnretained(self)
            .bind { vc, _ in
                if vc.mainView.authButton.backgroundColor == .sesacGreen {
                    
                    let month = Int(vc.mainView.monthView.textField.text!)! * 100
                    let day = Int(vc.mainView.dayView.textField.text!)!
                    let year = vc.mainView.datePicker.date
                    
                    if vc.viewModel.ageCalculate(months: month, days: day, year: year) {
                        UserManager.birth = vc.mainView.datePicker.date
                        vc.transition(EmailViewController(), transitionStyle: .push)
                    } else {
                        vc.mainView.makeToast(Comment.Signup.birthValid, position: .center)
                    }
                }
                
            }
            .disposed(by: disposeBag)
    }
}
