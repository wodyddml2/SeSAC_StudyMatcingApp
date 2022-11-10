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
        print(UserManager.nickname) 
        navigationBackButton()
        
        mainView.datePicker.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .bind { vc, _ in
                let date = vc.mainView.datePicker.date
                
                vc.mainView.yearView.textField.text = vc.viewModel.datePickerFormat(dateFormat: "yyyy", date: date)
                
                vc.mainView.monthView.textField.text = vc.viewModel.datePickerFormat(dateFormat: "M", date: date)
                
                vc.mainView.dayView.textField.text = vc.viewModel.datePickerFormat(dateFormat: "d", date: date)
                
            }
            .disposed(by: disposeBag)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.yearView.textField.becomeFirstResponder()
    }
    

}
