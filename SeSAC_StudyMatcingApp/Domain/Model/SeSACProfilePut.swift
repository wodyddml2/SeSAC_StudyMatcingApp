//
//  SeSACProfilePut.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/16.
//

import Foundation

struct SeSACProfilePut: Codable {
    let gender: Int
    let study: String
    let searchable: Int
    let ageMin: Int
    let ageMax: Int
    
    enum CodingKeys: String, CodingKey {
        case gender, study, ageMin, ageMax, searchable
    }
}

