//
//  ShopSectionModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/12/04.
//

import Foundation

import RxDataSources

struct ShopModel {
    var name: String
    var info: String
    var price: String
}

struct ShopSectionModel {
    var items: [Item]
}

extension ShopSectionModel: SectionModelType {
    
    typealias Item = ShopModel
    
    init(original: ShopSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
