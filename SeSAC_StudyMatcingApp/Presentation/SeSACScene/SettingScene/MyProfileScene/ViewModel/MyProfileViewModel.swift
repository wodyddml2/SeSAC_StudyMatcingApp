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
        
        SeSACAPIService.shared.requestSeSACAPI(type: SESACLoginDTO.self ,router: UserRouter.login(query: UserManager.idToken)) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                output.sesacInfo.onNext(success.toDomain())
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    self.renwalGetIdToken { [weak self] in
                        guard let self = self else {return}
                        self.requsetProfile(output: output)
                    }
                default:
                    output.networkFailed.accept(true)
                }
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
