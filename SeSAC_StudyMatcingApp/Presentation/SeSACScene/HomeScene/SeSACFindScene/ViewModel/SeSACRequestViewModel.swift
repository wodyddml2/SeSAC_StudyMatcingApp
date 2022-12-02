//
//  SeSACFindViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/19.
//

import Foundation
import CoreLocation

import FirebaseAuth
import RxSwift
import RxCocoa


final class SeSACRequestViewModel {
    let disposeBag = DisposeBag()
    
    var locationValue: CLLocationCoordinate2D?
    
    var searchSesac = PublishRelay<Bool>()
    
    var match = PublishSubject<SeSACMatchDTO>()
    var matchError = PublishRelay<Bool>()
}

extension SeSACRequestViewModel {
    func requsetSearch(output: Output) {
        
        guard let location = locationValue else {return}
        
        SeSACAPIService.shared.requestSeSACAPI(type: SeSACSearchDTO.self ,router: QueueRouter.search(query: UserManager.idToken, lat: location.latitude, long: location.longitude)) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                output.sesacInfo.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    self.renwalGetIdToken { [weak self] in
                        guard let self = self else {return}
                        self.requsetSearch(output: output)
                    }
                default:
                    output.networkFailed.accept(true)
                }
            }
        }
    }

    
    func requestFindDelete(completion: @escaping (Int) -> Void) {
        SeSACAPIService.shared.requestStatusSeSACAPI(router: QueueRouter.findDelete(query: UserManager.idToken)) { value in
            completion(value)
        }
    }
    
    func requestMYQueue() {
        SeSACAPIService.shared.requestSeSACAPI(type: SeSACMatchDTO.self, router: QueueRouter.match(query: UserManager.idToken)) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                self.match.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    self.renwalGetIdToken { [weak self] in
                        guard let self = self else {return}
                        self.requestMYQueue()
                    }
                default:
                    self.matchError.accept(true)
                }
            }
        }
    }
}

extension SeSACRequestViewModel: ViewModelType {
    
    struct Input {
        let reload: ControlEvent<Void>
        let change: ControlEvent<Void>
        let refresh: ControlEvent<Void>
        let tableItem: ControlEvent<IndexPath>
    }
    
    struct Output {
        var sesacInfo = PublishSubject<SeSACSearchDTO>()
        var networkFailed = PublishRelay<Bool>()
        var searchSesac: PublishRelay<Bool>
        let reload: ControlEvent<Void>
        let change: ControlEvent<Void>
        let refresh: ControlEvent<Void>
        let tableItem: ControlEvent<IndexPath>
    }
    
    func transform(input: Input) -> Output {
        let output = Output(searchSesac: searchSesac, reload: input.reload, change: input.change, refresh: input.refresh, tableItem: input.tableItem)
        
        return output
    }
}
