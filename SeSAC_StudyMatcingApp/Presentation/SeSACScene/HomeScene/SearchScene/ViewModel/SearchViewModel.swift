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
    
    func arrCountLimit() -> Bool {
        return myStudyArr.count > 9 ? true : false
    }
    

}
