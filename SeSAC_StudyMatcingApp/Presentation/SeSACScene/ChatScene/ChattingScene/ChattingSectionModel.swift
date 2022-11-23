//
//  ChattingSectionModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/23.
//

import Foundation

import RxDataSources

struct ChattingSectionModel {
    var items: [Item]
}

extension ChattingSectionModel: SectionModelType {
    
    typealias Item = SeSACChat
    
    init(original: ChattingSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
