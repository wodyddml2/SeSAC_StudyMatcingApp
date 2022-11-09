//
//  NicknameViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import Foundation

import RxSwift
import RxCocoa

class NicknameViewModel: ViewModelType {
    struct Input {
        let valid: ControlProperty<String?>
        let beginEdit: ControlEvent<Void>
        let endEdit: ControlEvent<Void>
    }
    
    struct Output {
        let valid: ControlProperty<String>
        let beginEdit: ControlEvent<Void>
        let endEdit: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let valid = input.valid.orEmpty
        return Output(valid: valid, beginEdit: input.beginEdit, endEdit: input.endEdit)
    }
}
