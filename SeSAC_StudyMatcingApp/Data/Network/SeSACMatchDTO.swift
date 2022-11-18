//
//  SeSACMatchDTO.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/18.
//

import Foundation

struct SeSACMatchDTO: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String?
}
