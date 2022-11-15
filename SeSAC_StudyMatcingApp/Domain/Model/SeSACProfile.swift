//
//  SeSACProfile.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/13.
//

import Foundation

struct SeSACProfile {
    let backgroundImage: Int
    let image: Int
    let nickname: String
    let sesacTitle: [Int]
    let comment: [String]
    let gender: Int
    let study: String
    let searchable: Int
    let ageMin: Int
    let ageMax: Int
    
    init(backgroundImage: Int = 3, image: Int = 0, nickname: String = "", sesacTitle: [Int] = [], comment: [String] = [], gender: Int = 0, study: String = "", searchable: Int = 0, ageMin: Int = 0, ageMax: Int = 0) {
        self.backgroundImage = backgroundImage
        self.image = image
        self.nickname = nickname
        self.sesacTitle = sesacTitle
        self.comment = comment
        self.gender = gender
        self.study = study
        self.searchable = searchable
        self.ageMin = ageMin
        self.ageMax = ageMax
    }
}
