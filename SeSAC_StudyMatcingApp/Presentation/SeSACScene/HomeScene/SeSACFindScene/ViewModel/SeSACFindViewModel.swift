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


class SeSACFindViewModel {
    let disposeBag = DisposeBag()
    
    var locationValue: CLLocationCoordinate2D?
    
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
}

extension SeSACFindViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        var sesacInfo = PublishSubject<SeSACSearchDTO>()
        var networkFailed = PublishRelay<Bool>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.requsetSearch(output: output)
            }
            .disposed(by: disposeBag)
 
        return output
    }
}
