//
//  SeSACFind.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/19.
//

import Foundation

struct SeSACFind {
    let uid: String
    let backgroundImage: Int
    let image: Int
    let nickname: String
    let sesacTitle: [Int]
    let comment: [String]
    let studyList: [String]
    
    init(uid: String = "", backgroundImage: Int = 0 , image: Int = 0, nickname: String = "", sesacTitle: [Int] = [], comment: [String] = [], studyList: [String] = []) {
        self.uid = uid
        self.backgroundImage = backgroundImage
        self.image = image
        self.nickname = nickname
        self.sesacTitle = sesacTitle
        self.comment = comment
        self.studyList = studyList
    }
}
