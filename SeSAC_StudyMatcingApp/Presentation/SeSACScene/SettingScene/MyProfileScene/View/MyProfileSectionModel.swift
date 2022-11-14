//
//  MyProfileSectionModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/14.
//
import UIKit

import RxDataSources

struct MyProfileModel {
    var title: String?
}

struct MyProfileSectionModel {
    var items: [Item]
}

extension MyProfileSectionModel: SectionModelType {
    
    typealias Item = MyProfileModel

    init(original: MyProfileSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
