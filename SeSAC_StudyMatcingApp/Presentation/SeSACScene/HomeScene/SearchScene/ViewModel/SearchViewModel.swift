//
//  SearchViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/17.
//

import Foundation

class SearchViewModel {
    var myStudyArr: [String] = []
    var arroundStudyArr: [String] = ["ss", "ssss", "sssss"]
    
    func overlapString(text: String) -> Bool {
        return myStudyArr.filter { text == $0 }.count > 0 ? true : false
    }
    
    func arrCountLimit() -> Bool {
        return myStudyArr.count > 9 ? true : false
    }
}
