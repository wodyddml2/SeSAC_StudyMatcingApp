//
//  MyProfileViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/15.
//

import Foundation

import FirebaseAuth
import RxSwift
import RxCocoa

final class MyProfileViewModel {

    let disposeBag = DisposeBag()
    
    func requsetProfile(output: Output) {
        
        SeSACAPIService.shared.requestSeSACAPI(type: SESACLoginDTO.self ,router: Router.loginGet(query: UserManager.idToken)) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                output.sesacInfo.onNext(success.toDomain())
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
                
                self.requsetProfile(output: output)
            }
        }
    }
    
    
}

extension MyProfileViewModel: ViewModelType {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let save: ControlEvent<Void>
    }
    
    struct Output {
        var sesacInfo = PublishSubject<SeSACProfile>()
        var networkFailed = PublishRelay<Bool>()
        let save: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let output = Output(save: input.save)
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.requsetProfile(output: output)
            }
            .disposed(by: disposeBag)
 
        return output
    }
}
