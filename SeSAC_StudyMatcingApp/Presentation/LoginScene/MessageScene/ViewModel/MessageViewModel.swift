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
    
    let authTimer = BehaviorRelay(value: false)
    
    struct Input {
        let auth: ControlEvent<Void>
        let valid: ControlProperty<String?>
    }
    
    struct Output {
        let auth: ControlEvent<Void>
        let valid: ControlProperty<String>
        let timer: Observable<Int>

    }
    
    func transform(input: Input) -> Output {
        let valid = input.valid.orEmpty
        let timer = Observable<Int>.timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
        return Output(auth: input.auth, valid: valid, timer: timer)
    }
}
