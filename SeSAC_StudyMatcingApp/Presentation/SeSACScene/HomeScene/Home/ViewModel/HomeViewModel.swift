//
//  HomeViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/18.
//

import Foundation
import FirebaseAuth

import RxSwift
import RxCocoa

enum MapGenderButton {
    case all
    case man
    case woman
}

final class HomeViewModel {
    let disposeBag = DisposeBag()
    
    var mapCameraMove = PublishRelay<Bool>()
    var matchBind = PublishRelay<Bool>()
    
    
    func requestSearchSeSAC(output: Output, lat: Double, long: Double) {
        SeSACAPIService.shared.requestSeSACAPI(type: SeSACSearchDTO.self, router: QueueRouter.searchPost(query: UserManager.idToken, lat: lat, long: long)) { result in
            switch result {
            case .success(let success):
                output.searchInfo.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    self.renwalGetIdToken { [weak self] in
                        guard let self = self else {return}
                        self.requestSearchSeSAC(output: output, lat: lat, long: long)
                    }
                default:
                    output.networkFailed.accept(true)
                }
            }
        }
    }
    
    func requestMatchSeSAC(output: Output) {
        SeSACAPIService.shared.requestSeSACAPI(type: SeSACMatchDTO.self, router: QueueRouter.matchGet(query: UserManager.idToken)) { result in
            switch result {
            case .success(let success):
                output.matchInfo.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .existingUsers:
                    output.normalStatus.accept(true)
                case .firebaseTokenError:
                    self.renwalGetIdToken { [weak self] in
                        guard let self = self else {return}
                        self.requestMatchSeSAC(output: output)
                    }
                default:
                    output.networkFailed.accept(true)
                }
            }
        }
    }
}

extension HomeViewModel: ViewModelType {
    struct Input {
        let match: ControlEvent<Void>
        let currentLocation: ControlEvent<Void>
        let all: ControlEvent<Void>
        let man: ControlEvent<Void>
        let woman: ControlEvent<Void>
    }
    
    struct Output {
        var searchInfo = PublishSubject<SeSACSearchDTO>()
        var matchInfo = PublishSubject<SeSACMatchDTO>()
        var networkFailed = PublishRelay<Bool>()
        var normalStatus = PublishRelay<Bool>()
        let match: ControlEvent<Void>
        let currentLocation: ControlEvent<Void>
        var mapCameraMove: PublishRelay<Bool>
        var matchBind: PublishRelay<Bool>
        let genderButton: Observable<MapGenderButton>
    }
    
    func transform(input: Input) -> Output {
        let genderButton = Observable.merge(
            input.all.map({_ in MapGenderButton.all}),
            input.man.map({_ in MapGenderButton.man}),
            input.woman.map({_ in MapGenderButton.woman})
        )
        
        
        return Output(match: input.match, currentLocation: input.currentLocation, mapCameraMove: mapCameraMove, matchBind: matchBind, genderButton: genderButton)
    }
}
