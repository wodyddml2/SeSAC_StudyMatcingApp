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


class SeSACRequestViewModel {
    let disposeBag = DisposeBag()
    
    var locationValue: CLLocationCoordinate2D?
    
    var searchSesac = PublishRelay<Bool>()
    
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
}

extension SeSACRequestViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        var sesacInfo = PublishSubject<SeSACSearchDTO>()
        var networkFailed = PublishRelay<Bool>()
        var searchSesac: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let output = Output(searchSesac: searchSesac)
        
//        input.viewDidLoadEvent
//            .withUnretained(self)
//            .subscribe { vc, _ in
//                vc.requsetSearch(output: output)
//            }
//            .disposed(by: disposeBag)
 
        return output
    }
}
