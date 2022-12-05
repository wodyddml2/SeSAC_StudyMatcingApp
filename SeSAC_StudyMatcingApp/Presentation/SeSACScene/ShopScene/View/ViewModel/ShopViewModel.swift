//
//  ShopViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/12/04.
//

import Foundation

import RxSwift
import RxCocoa

class ShopViewModel {
    let disposeBag = DisposeBag()

    func requestInfo(output: Output) {
        SeSACAPIService.shared.requestSeSACAPI(type: SESACLoginDTO.self, router: ShopRouter.myInfo(query: UserManager.idToken)) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                output.myInfo.onNext(success.toMyInfo())
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    self.renwalGetIdToken {
                        self.requestInfo(output: output)
                    }
                default:
                    output.infoFailed.accept(true)
                }
            }
        }
    }
    
    func requestItem(output: Output, sesac: Int, background: Int) {
        SeSACAPIService.shared.requestStatusSeSACAPI(router: ShopRouter.item(query: UserManager.idToken, sesac: "\(sesac)", background: "\(background)")) {[weak self] value in
            guard let self = self else {return}
            switch StatusCode(rawValue: value) {
            case .success:
                output.updateSuccess.accept(true)
            case .declarationOrMatch:
                output.updateSuccess.accept(false)
            case .firebaseError:
                self.renwalGetIdToken {
                    self.requestItem(output: output,sesac: sesac, background: background)
                }
            default:
                output.infoFailed.accept(true)
            }
        }
    }
}

extension ShopViewModel: ViewModelType {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let myInfo = BehaviorSubject<SeSACMyInfo>(value: SeSACMyInfo())
        let infoFailed = BehaviorRelay<Bool>(value: false)
        let updateSuccess = PublishRelay<Bool>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.requestInfo(output: output)
            }
            .disposed(by: disposeBag)
        return output
    }
}
