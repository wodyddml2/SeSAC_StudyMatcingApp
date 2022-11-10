//
//  EmailViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import Foundation

import RxSwift
import RxCocoa

class EmailViewModel: ViewModelType {
    struct Input {
        let nextButton: ControlEvent<Void>
        let valid: ControlProperty<String?>
    }
    
    struct Output {
        let nextButton: ControlEvent<Void>
        let valid: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let valid = input.valid
            .orEmpty
            .withUnretained(self)
            .map { vm, value in
                vm.validateEmail(value)
        }
        return Output(nextButton: input.nextButton, valid: valid)
    }
    
    func validateEmail(_ text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z]{2,16}+@[A-Za-z0-9]{4,16}+\\.[A-Za-z]{2,10}"
        return text.range(of: emailRegEx, options: .regularExpression) != nil
    }
}
