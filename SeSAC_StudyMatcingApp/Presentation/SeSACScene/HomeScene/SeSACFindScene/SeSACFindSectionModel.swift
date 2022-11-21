//
//  SeSACFindSectionModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/19.
//

import Foundation

import RxDataSources

struct SeSACFindSectionModel {
    var items: [Item]
}

extension SeSACFindSectionModel: SectionModelType {
    
    typealias Item = SeSACFind

    init(original: SeSACFindSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
