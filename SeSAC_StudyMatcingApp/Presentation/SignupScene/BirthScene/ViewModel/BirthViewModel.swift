//
//  BirthViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import Foundation

import RxSwift
import RxCocoa

class BirthViewModel: ViewModelType {
    struct Input {
        let nextButton: ControlEvent<Void>
        let datePicker: ControlEvent<Void>
    }
    
    struct Output {
        let nextButton: ControlEvent<Void>
        let datePicker: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {

        return Output(nextButton: input.nextButton, datePicker: input.datePicker)
    }
    
    func datePickerFormat(dateFormat: String, date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    
    func ageCalculate(months: Int, days: Int, year: Date) -> Bool {
        let componentDate = Calendar.current.dateComponents([.year], from: year, to: Date())
        
        guard let year = componentDate.year else {return false}

        let month = months
        let day = days
    
        let currentMonth = Int(datePickerFormat(dateFormat: "M", date: Date()))! * 100
        let currentDay = Int(datePickerFormat(dateFormat: "d", date: Date()))!
        
        if (year - 17 == 0 && (month + day) <= (currentMonth + currentDay)) || year - 17 >= 0 {
             return true // 만 17세 이상
        } else {
            return false
        }

    }

}
