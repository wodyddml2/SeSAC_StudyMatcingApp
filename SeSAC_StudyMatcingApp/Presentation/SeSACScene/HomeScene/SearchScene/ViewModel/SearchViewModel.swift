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
        SeSACAPIService.shared.requestSeSACAPI(type: SeSACSearchDTO.self, router: Router.searchPost(query: UserManager.idToken, lat: location.latitude, long: location.longitude)) { result in
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
    
    func requestSeSACUser(completion: @escaping (Int) -> Void) {
        guard let location = locationValue else {return}
        var studylist: [String] = []
        myStudyArr.forEach { study in
            studylist.append(study.title)
        }
        SeSACAPIService.shared.requestStatusSeSACAPI(router: Router.findPost(query: UserManager.idToken, lat: location.latitude, long: location.longitude, list: studylist)) { value in
            completion(value)
        }
    }
    
    func renewalSeSACUserRequest(completion: @escaping () -> Void) {
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

extension SearchViewModel: ViewModelType {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let searchTap: ControlEvent<Void>
        let buttonTap: ControlEvent<Void>
    }
    
    struct Output {
        var sesacInfo = PublishSubject<SeSACSearchDTO>()
        var networkFailed = PublishRelay<Bool>()
        let searchTap: ControlEvent<Void>
        let buttonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let output = Output(searchTap: input.searchTap, buttonTap: input.buttonTap)
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.requestSearchSeSAC(output: output)
            }
            .disposed(by: disposeBag)
 
        return output
    }
}
