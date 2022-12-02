//
//  SeSACReviewViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/30.
//

import Foundation

import FirebaseAuth
import RxSwift
import RxCocoa

enum ReviewButton {
    case manner
    case promise
    case fast
    case kind
    case skill
    case beneficial
}

class SeSACReviewViewModel {
    var nick: String = ""
    var uid: String = ""
    
    func requestRate(output: Output, list: [Int], comment: String) {
        SeSACAPIService.shared.requestStatusSeSACAPI(router: QueueRouter.rate(query: UserManager.idToken, uid: uid, list: list, comment: comment)) {  [weak self] value in
            guard let self = self else {return}
            switch StatusCode(rawValue: value) {
            case .success:
                output.success.accept(true)
            case .firebaseError:
                self.renwalGetIdToken { [weak self] in
                    guard let self = self else {return}
                    self.requestRate(output: output, list: list, comment: comment)
                }
            default:
                print(value)
                output.networkFailed.accept(true)
            }
        }
    }
}

extension SeSACReviewViewModel: ViewModelType {
    struct Input {
        let manner: ControlEvent<Void>
        let promise: ControlEvent<Void>
        let fast: ControlEvent<Void>
        let kind: ControlEvent<Void>
        let skill: ControlEvent<Void>
        let beneficial: ControlEvent<Void>
    }
    
    struct Output {
        let reviewButton: Observable<ReviewButton>
        var networkFailed = PublishRelay<Bool>()
        var success = PublishRelay<Bool>()
    }
    
    func transform(input: Input) -> Output {
        let reviewButton = Observable.merge(
            input.manner.map({_ in ReviewButton.manner}),
            input.promise.map({_ in ReviewButton.promise}),
            input.fast.map({_ in ReviewButton.fast}),
            input.kind.map({_ in ReviewButton.kind}),
            input.skill.map({_ in ReviewButton.skill}),
            input.beneficial.map({_ in ReviewButton.beneficial})
        )
        
        
        return Output(reviewButton: reviewButton)
    }
}
