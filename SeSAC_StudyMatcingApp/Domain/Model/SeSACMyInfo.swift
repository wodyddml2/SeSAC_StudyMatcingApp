//
//  SeSACMyInfo.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/12/04.
//

import Foundation

struct SeSACMyInfo {
    let sesac: Int
    let sesacCollection: [Int]
    let background: Int
    let backgroundCollection: [Int]
    
    init(sesac: Int = 0, sesacCollection: [Int] = [], background: Int = 0, backgroundCollection: [Int] = []) {
        self.sesac = sesac
        self.sesacCollection = sesacCollection
        self.background = background
        self.backgroundCollection = backgroundCollection
    }
}
