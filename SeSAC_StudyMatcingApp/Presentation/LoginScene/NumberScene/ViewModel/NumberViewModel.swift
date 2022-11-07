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
    }
    
    struct Output {
        let numberText: ControlEvent<String>
    }
    
    func transform(input: Input) -> Output {
        let numberText = input.numberText
            .orEmpty
            .changed
        return Output(numberText: numberText)
    }
}
