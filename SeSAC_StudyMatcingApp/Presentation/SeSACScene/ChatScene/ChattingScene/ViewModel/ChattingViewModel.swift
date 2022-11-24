//
//  ChattingViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/24.
//

import Foundation

import FirebaseAuth
import RxSwift
import RxCocoa

class ChattingViewModel {
    
    let disposeBag = DisposeBag()
    
    func requestMyQueue(output: Output) {
        SeSACAPIService.shared.requestSeSACAPI(type: SeSACMatchDTO.self, router: Router.matchGet(query: UserManager.idToken)) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                output.matchInfo.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    self.renewalMyQueue(output: output)
                default:
                    output.networkFailed.accept(true)
                }
            }
        }
    }
    
    func renewalMyQueue(output: Output) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else {return}
            if error != nil {
                output.networkFailed.accept(true)
                return
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                
                self.requestMyQueue(output: output)
            }
        }
    }
    
    func requestDodge() {
        
    }
    
    func renewalDodge() {
        
    }
    
}

extension ChattingViewModel: ViewModelType {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let backButton: ControlEvent<Void>
    }
    
    struct Output {
        var matchInfo = PublishSubject<SeSACMatchDTO>()
        var networkFailed = PublishRelay<Bool>()
        let backButton: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let output = Output(backButton: input.backButton)
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.requestMyQueue(output: output)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
