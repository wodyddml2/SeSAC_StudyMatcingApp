//
//  SeSAC.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/12/04.
//

import Foundation

//struct Info {
//    let name: String
//    let info: String
//}

//struct SeSAC {
//    let sesac: [Info] = [Info(name: "기본 새싹", info: "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다."),
//                         Info(name: "튼튼 새싹", info: "잎이 하나 더 자라나고 튼튼해진 새나라의 새싹으로 같이 있으면 즐거워집니다."),
//                         Info(name: "민트 새싹", info: "호불호의 대명사! 상쾌한 향이 나서 허브가 대중화된 지역에서 많이 자랍니다."),
//                         Info(name: "퍼플 새싹", info: "감정을 편안하게 쉬도록 하며 슬프고 우울한 감정을 진정시켜주는 멋진 새싹입니다."),
//                         Info(name: "골드 새싹", info: "화려하고 멋있는 삶을 살며 돈과 인생을 플렉스 하는 자유분방한 새싹입니다.")]
//
//    let background: [Info] = [Info(name: "하늘 공원", info: "새싹들을 많이 마주치는 매력적인 하늘 공원입니다"),
//                              Info(name: "씨티 뷰", info: "창밖으로 보이는 도시 야경이 아름다운 공간입니다"),
//                              Info(name: "밤의 산책로", info: "어둡지만 무섭지 않은 조용한 산책로입니다"),
//                              Info(name: "낮의 산책로", info: "즐겁고 가볍게 걸을 수 있는 산책로입니다"),
//                              Info(name: "연극 무대", info: "연극의 주인공이 되어 연기를 펼칠 수 있는 무대입니다"),
//                              Info(name: "라틴 거실", info: "모노톤의 따스한 감성의 거실로 편하게 쉴 수 있는 공간입니다"),
//                              Info(name: "홈트방", info: "집에서 운동을 할 수 있도록 기구를 갖춘 방입니다"),
//                              Info(name: "뮤지션 작업실", info: "여러가지 음악 작업을 할 수 있는 작업실입니다")]
//}

enum SeSAC: CaseIterable {
    case normal
    case strong
    case mint
    case purple
    case gold
    
    var name: String {
        switch self {
        case .normal:
            return "기본 새싹"
        case .strong:
            return "튼튼 새싹"
        case .mint:
            return "민트 새싹"
        case .purple:
            return "퍼플 새싹"
        case .gold:
            return "골드 새싹"
        }
    }
    
    var info: String {
        switch self {
        case .normal:
            return "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다."
        case .strong:
            return "잎이 하나 더 자라나고 튼튼해진 새나라의 새싹으로 같이 있으면 즐거워집니다."
        case .mint:
            return "호불호의 대명사! 상쾌한 향이 나서 허브가 대중화된 지역에서 많이 자랍니다."
        case .purple:
            return "감정을 편안하게 쉬도록 하며 슬프고 우울한 감정을 진정시켜주는 멋진 새싹입니다."
        case .gold:
            return "화려하고 멋있는 삶을 살며 돈과 인생을 플렉스 하는 자유분방한 새싹입니다."
        }
    }
    
    var price: String {
        switch self {
        case .normal:
            return "보유"
        case .strong:
            return "1,200"
        case .mint, .purple, .gold:
            return "2,500"
        }
    }
}

enum SeSACBackground: CaseIterable {
    case sky
    case cityView
    case night
    case morning
    case theaters
    case latins
    case training
    case musician
    
    var name: String {
        switch self {
        case .sky:
            return "하늘 공원"
        case .cityView:
            return "씨티 뷰"
        case .night:
            return "밤의 산책로"
        case .morning:
            return "낮의 산책로"
        case .theaters:
            return "연극 무대"
        case .latins:
            return "라틴 거실"
        case .training:
            return "홈트방"
        case .musician:
            return "뮤지션 작업실"
        }
    }
    
    var info: String {
        switch self {
        case .sky:
            return "새싹들을 많이 마주치는 매력적인 하늘 공원입니다"
        case .cityView:
            return "창밖으로 보이는 도시 야경이 아름다운 공간입니다"
        case .night:
            return "어둡지만 무섭지 않은 조용한 산책로입니다"
        case .morning:
            return "즐겁고 가볍게 걸을 수 있는 산책로입니다"
        case .theaters:
            return "연극의 주인공이 되어 연기를 펼칠 수 있는 무대입니다"
        case .latins:
            return "모노톤의 따스한 감성의 거실로 편하게 쉴 수 있는 공간입니다"
        case .training:
            return "집에서 운동을 할 수 있도록 기구를 갖춘 방입니다"
        case .musician:
            return "여러가지 음악 작업을 할 수 있는 작업실입니다"
        }
    }
    
    var price: String {
        switch self {
        case .sky:
            return "보유"
        case .cityView, .night, .morning:
            return "1,200"
        case .theaters, .latins, .training, .musician:
            return "2,500"
        }
    }
}
