//
//  ProfileSectionModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/13.
//

import UIKit

import RxDataSources

struct SettingModel {
    var leftImage: UIImage
    var title: String
}

struct SettingSectionModel {
    var items: [Item]
}

extension SettingSectionModel: SectionModelType {
    
    typealias Item = SettingModel

    init(original: SettingSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
