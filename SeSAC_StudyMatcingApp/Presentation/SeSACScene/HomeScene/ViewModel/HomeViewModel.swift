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

class HomeViewModel {
    let disposeBag = DisposeBag()
    
    private func requestSearchSeSAC(output: Output, lat: Double, long: Double) {
        SeSACAPIService.shared.requestSeSACAPI(type: SeSACSearchDTO.self, router: Router.searchPost(query: UserManager.idToken, lat: lat, long: long)) { result in
            switch result {
            case .success(let success):
                output.searchInfo.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    self.renewalSearchRequest(output: output, lat: lat, long: long)
                default:
                    output.networkFailed.accept(true)
                }
            }
        }
    }
    
    private func renewalSearchRequest(output: Output, lat: Double, long: Double) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else {return}
            if error != nil {
                output.networkFailed.accept(true)
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                
                self.requestSearchSeSAC(output: output, lat: lat, long: long)
            }
        }
    }
    
    
    private func requestMatchSeSAC(output: Output) {
        SeSACAPIService.shared.requestSeSACAPI(type: SeSACMatchDTO.self, router: Router.matchGet(query: UserManager.idToken)) { result in
            switch result {
            case .success(let success):
                output.matchInfo.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .existingUsers:
                    output.normalStatus.accept(true)
                case .firebaseTokenError:
                    self.renewalMatchRequest(output: output)
                default:
                    output.networkFailed.accept(true)
                }
            }
        }
    }
    
    private func renewalMatchRequest(output: Output) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else {return}
            if error != nil {
                output.networkFailed.accept(true)
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                
                self.requestMatchSeSAC(output: output)
            }
        }
    }
}

extension HomeViewModel: ViewModelType {
    
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let lat: Double
        let long: Double
    }
    
    struct Output {
        var searchInfo = PublishSubject<SeSACSearchDTO>()
        var matchInfo = PublishSubject<SeSACMatchDTO>()
        var networkFailed = PublishRelay<Bool>()
        var normalStatus = PublishRelay<Bool>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.requestMatchSeSAC(output: output)
                vc.requestSearchSeSAC(output: output, lat: input.lat, long: input.long)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
