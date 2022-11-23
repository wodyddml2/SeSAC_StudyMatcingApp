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
        
        SeSACAPIService.shared.requestSeSACAPI(type: SeSACSearchDTO.self ,router: Router.searchPost(query: UserManager.idToken, lat: 37.517819364682694, long: 126.88647317074734)) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                output.sesacInfo.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    
                    self.renewalRequest(output: output)
                default:
                    output.networkFailed.accept(true)
                }
            }
        }
    }
    
    private func renewalRequest(output: Output) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else {return}
            if error != nil {
                output.networkFailed.accept(true)
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                
                self.requsetSearch(output: output)
            }
        }
    }
    
    func requestFindDelete(completion: @escaping (Int) -> Void) {
        SeSACAPIService.shared.requestStatusSeSACAPI(router: Router.findDelete(query: UserManager.idToken)) { value in
            completion(value)
        }
    }
    
    func renewalFindDeleteRequest(completion: @escaping () -> Void) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if error != nil {
                print("error")
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                
                completion()
            }
        }
    }
    
    func requestMYQueue() {
        SeSACAPIService.shared.requestSeSACAPI(type: SeSACMatchDTO.self, router: Router.matchGet(query: UserManager.idToken)) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                self.match.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    self.renewalMyQueueRequest()
                default:
                    self.matchError.accept(true)
                }
            }
        }
    }
    
    func renewalMyQueueRequest() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if error != nil {
                print("error")
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                
                self.requestMYQueue()
            }
        }
    }
}

extension SeSACRequestViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
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
