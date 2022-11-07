//
//  LoginViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

import RxSwift

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
        
    }
    
    private func format(with mask: String, phone: String) -> String {
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
    
    func valdatePhone(num: String) -> Bool {
        let regex = "^010-?([0-9]{4})-?([0-9]{4})"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: num)
    }
}

extension NumberViewController {
    private func bindTo() {
        
        let input = NumberViewModel.Input(numberText: mainView.numberTextField.rx.text)
        
        let output = viewModel.transform(input: input)
        
        output.numberText
            .withUnretained(self)
            .bind { vc, value in
                vc.mainView.numberTextField.text = vc.format(with: "XXX-XXXX-XXXX", phone: value)
            }
            .disposed(by: disposeBag)
      
    }
}
