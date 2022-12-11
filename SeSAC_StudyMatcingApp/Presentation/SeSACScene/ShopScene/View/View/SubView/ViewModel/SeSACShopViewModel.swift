//
//  SeSACShopViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/12/05.
//

import Foundation

import RxSwift
import RxCocoa

class SeSACShopViewModel {
    let disposeBag = DisposeBag()
    
    var sesacCollection = BehaviorSubject<[Int]>(value: [0])
    var backgroundCollection = BehaviorSubject<[Int]>(value: [0])
    var sesacArr: [Int] = []
    
    var sesacSections = PublishSubject<[ShopSectionModel]>()
    
    let myInfo = BehaviorSubject<SeSACMyInfo>(value: SeSACMyInfo())
    let infoFailed = BehaviorRelay<Bool>(value: false)
    
    func requestInfo() {
        SeSACAPIService.shared.requestSeSACAPI(type: SESACLoginDTO.self, router: ShopRouter.myInfo(query: UserManager.idToken)) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                self.myInfo.onNext(success.toMyInfo())
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    self.renwalGetIdToken {
                        self.requestInfo()
                    }
                default:
                    self.infoFailed.accept(true)
                }
            }
        }
    }
    
    func requestiOS(receipt: String, product: String) {
        SeSACAPIService.shared.requestStatusSeSACAPI(router: ShopRouter.ios(query: UserManager.idToken, receipt: receipt, product: product)) { [weak self] value in
            guard let self = self else {return}
            switch StatusCode(rawValue: value) {
            case .success:
                self.requestInfo()
            case .declarationOrMatch:
                print("201")
            case .firebaseError:
                self.renwalGetIdToken {
                    self.requestiOS(receipt: receipt, product: product)
                }
            default:
                print("fail")
            }
        }
    }
}

extension SeSACShopViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        return output
    }
    
    
}
