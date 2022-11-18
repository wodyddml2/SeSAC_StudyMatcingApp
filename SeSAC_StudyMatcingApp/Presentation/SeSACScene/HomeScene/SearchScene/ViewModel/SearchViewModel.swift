//
//  SearchViewModel.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/17.
//

import Foundation
import CoreLocation
import FirebaseAuth

import RxSwift
import RxCocoa

struct StudyTag: Hashable {
    let id = UUID().uuidString
    
    var title: String
}

class SearchViewModel {
    
    var myStudyArr: [StudyTag] = []
    var recommendArr: [StudyTag] = []
    var aroundStudyArr: [StudyTag] = []
    var setAround: [String] = []
    
    var locationValue: CLLocationCoordinate2D?
   
    let disposeBag = DisposeBag()
    
    func arrCountLimit() -> Bool {
        return myStudyArr.count >= 8 ? true : false
    }
    
    private func requestSearchSeSAC(output: Output) {
        guard let location = locationValue else {return}
        SeSACAPIService.shared.requestSeSACAPI(type: SeSACSearchDTO.self, router: Router.searchPost(query: UserManager.idToken, lat: 37.517819364682694, long: 126.88647317074734)) { result in
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
                
                self.requestSearchSeSAC(output: output)
            }
        }
    }

}

extension SearchViewModel: ViewModelType {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let searchTap: ControlEvent<Void>
    }
    
    struct Output {
        var sesacInfo = PublishSubject<SeSACSearchDTO>()
        var networkFailed = PublishRelay<Bool>()
        let searchTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let output = Output(searchTap: input.searchTap)
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.requestSearchSeSAC(output: output)
            }
            .disposed(by: disposeBag)
 
        return output
    }
}
