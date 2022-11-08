//
//  MessageViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import Foundation

import RxSwift
import RxCocoa

class MessageViewModel: ViewModelType {
    struct Input {
        let auth: ControlEvent<Void>
        let valid: ControlProperty<String?>
    }
    
    struct Output {
        let auth: ControlEvent<Void>
        let valid: ControlProperty<String>
    }
    
    func transform(input: Input) -> Output {
        let valid = input.valid.orEmpty
        return Output(auth: input.auth, valid: valid)
    }
}
