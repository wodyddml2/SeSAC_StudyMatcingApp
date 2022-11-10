//
//  BirthViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import Foundation

class BirthViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    func datePickerFormat(dateFormat: String, date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

}
