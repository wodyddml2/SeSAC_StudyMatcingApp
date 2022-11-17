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
    
    
    private func requestMatchSeSAC(output: Output) {
        SeSACAPIService.shared.requestSeSACAPI(type: SESACMatchDTO.self, router: Router.matchGet(query: UserManager.idToken)) { result in
            switch result {
            case .success(let success):
                output.sesacInfo.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .existingUsers:
                    output.normalStatus.accept(true)
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
                
                self.requestMatchSeSAC(output: output)
            }
        }
    }
}

extension HomeViewModel: ViewModelType {
    
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        var sesacInfo = PublishSubject<SESACMatchDTO>()
        var networkFailed = PublishRelay<Bool>()
        var normalStatus = PublishRelay<Bool>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.requestMatchSeSAC(output: output)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
