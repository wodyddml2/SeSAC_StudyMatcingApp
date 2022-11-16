//
//  MyProfileSectionModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/14.
//
import UIKit

import RxDataSources

struct MyProfileSectionModel {
    var items: [Item]
}

extension MyProfileSectionModel: SectionModelType {
    
    typealias Item = SeSACProfileGet

    init(original: MyProfileSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
