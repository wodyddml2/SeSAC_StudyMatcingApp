//
//  NumberViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import Foundation

import RxSwift
import RxCocoa

final class NumberViewModel: ViewModelType {
    struct Input {
        let numberText: ControlProperty<String?>
        let beginEdit: ControlEvent<Void>
        let endEdit: ControlEvent<Void>
        let auth: ControlEvent<Void>
    }
    
    struct Output {
        let numberText: ControlEvent<String>
        let beginEdit: ControlEvent<Void>
        let endEdit: ControlEvent<Void>
        let auth: ControlEvent<Void>
        let numberValid: Observable<Bool>
    }
    
    func valdatePhone(num: String) -> Bool {
        let regex = "^01[0|1]-?([0-9]{3,4})-?([0-9]{4})"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: num)
    }
    
    func transform(input: Input) -> Output {
        let numberText = input.numberText
            .orEmpty
            .changed
        
        let numberValid = input.numberText
            .orEmpty
            .changed
            .withUnretained(self)
            .map { vm, value in
                vm.valdatePhone(num: value)
            }
        return Output(numberText: numberText, beginEdit: input.beginEdit, endEdit: input.endEdit, auth: input.auth, numberValid: numberValid)
    }
}
