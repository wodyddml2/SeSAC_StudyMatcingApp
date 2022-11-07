//
//  ViewModelType.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import Foundation

import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
  
}
