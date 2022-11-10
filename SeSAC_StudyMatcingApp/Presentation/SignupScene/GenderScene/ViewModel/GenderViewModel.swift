//
//  GenderViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import Foundation

import RxSwift
import RxCocoa

class GenderViewModel: ViewModelType {
    
    struct Input {
        let manButton: ControlEvent<Void>
        let womanButton: ControlEvent<Void>
        let nextButton: ControlEvent<Void>
     
    }
    
    struct Output {
        let manButton: ControlEvent<Void>
        let womanButton: ControlEvent<Void>
        let nextButton: ControlEvent<Void>

    }
    
    func transform(input: Input) -> Output {
        
        return Output(manButton: input.manButton, womanButton: input.womanButton,nextButton: input.nextButton)
    }
}
