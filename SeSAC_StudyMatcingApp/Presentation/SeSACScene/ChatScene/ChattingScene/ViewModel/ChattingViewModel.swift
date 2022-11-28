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
    
    var chatInfo = PublishSubject<SeSACChatGetDTO>()
    var postInfo = PublishSubject<SeSACChatPostDTO>()
    var postFailed = PublishRelay<Bool>()
    var getFailed = PublishRelay<Bool>()
    
    var chat = PublishSubject<[ChattingSectionModel]>()
    var sections: [ChattingSectionModel] = []
    
    var uid: String = ""
    var lastDate: Date = Date()
    
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
    
    func requestChatPost(chat: String) {
        ChattingAPIService.shared.requestPOSTAPI(router: ChatRouter.chatPost(query: UserManager.idToken, path: uid, chat: chat)) { [weak self] result in
            
            guard let self = self else {return}
            switch result {
            case .success(let success):
                self.postInfo.onNext(success)
                print("=======\(success)")
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    self.renewalChatPost(chat: chat)
                default:
                    self.postFailed.accept(true)
                }
            }
        }
    }
    
    func renewalChatPost(chat: String) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else {return}
            if error != nil {
                self.getFailed.accept(true)
                return
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                self.requestChatPost(chat: chat)
            }
        }
    }
    
    func requestChatGet(lastchatDate: String) {
        ChattingAPIService.shared.requestGETAPI(router: ChatRouter.chatGet(query: UserManager.idToken, path: uid, lastchatDate: lastchatDate)) { [weak self] result in
            
            guard let self = self else {return}
            switch result {
            case .success(let success):
                ChattingSocketService.shared.establishConnection()
                self.chatInfo.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    self.renewalChatGet(lastchatDate: lastchatDate)
                default:
                    self.getFailed.accept(true)
                }
            }
        }
    }
    
    func renewalChatGet(lastchatDate: String) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else {return}
            if error != nil {
                self.postFailed.accept(true)
                return
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                
                self.requestChatGet(lastchatDate: lastchatDate)
            }
        }
    }
    
    
}

extension ChattingViewModel: ViewModelType {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let backButton: ControlEvent<Void>
        let declarationTap: ControlEvent<Void>
        let sendTap: ControlEvent<Void>
    }
    
    struct Output {
        var matchInfo = PublishSubject<SeSACMatchDTO>()
        var networkFailed = PublishRelay<Bool>()
        let backButton: ControlEvent<Void>
        let declarationTap: ControlEvent<Void>
        let sendTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            backButton: input.backButton,
            declarationTap: input.declarationTap,
            sendTap: input.sendTap
        )
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.requestMyQueue(output: output)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

extension ChattingViewModel {
    func sectionItems(_ payload: Payload) -> SeSACChat {
        var dateFormat: String = ""
        if Date().nowDateFormat(date: "yyyy/M/d") == payload.createdAt.toDate().dateStringFormat(date: "yyyy/M/d") {
            dateFormat = "a HH:mm"
        } else {
            dateFormat = "M/d a HH:mm"
        }
        return SeSACChat(
            message: payload.chat,
            createdAt: payload.createdAt.toDate().dateStringFormat(date: dateFormat),
            sectionDate: payload.createdAt.toDate().dateStringFormat(date: "M월 d일 EEEE"),
            from: payload.from,
            uid: payload.to
        )
    }
    
    func sectionItem(item: SeSACChat) {
        var sectionCount = sections.isEmpty ? 0 : sections.count - 1
        let rowCount = sections[sectionCount].items.count - 1

        if sections.isEmpty {
            sections.append(ChattingSectionModel(items: [SeSACChat(sectionDate: item.sectionDate)]))
            sections[sectionCount].items.append(item)
        } else {
            if sections[sectionCount].items[rowCount].sectionDate == item.sectionDate {
                sections[sectionCount].items.append(item)
            } else {
                sectionCount += 1
                sections.append(ChattingSectionModel(items: [SeSACChat(sectionDate: item.sectionDate)]))
                sections[sectionCount].items.append(item)
            }
        }
    }
    
    
    func bindChatInfo() {
        chatInfo
            .withUnretained(self)
            .subscribe (onNext: { vc, info in
                var sectionCount = 0
                for i in 0...info.payload.count - 1 {
                    let sectionItem = vc.sectionItems(info.payload[i])
                    
                    if i == 0 {
                        vc.sections.append(ChattingSectionModel(items: [SeSACChat(sectionDate: info.payload[i].createdAt.toDate().dateStringFormat(date: "M월 d일 EEEE"))]))
                        vc.sections[sectionCount].items.append(sectionItem)
                    } else {
                        if info.payload[i].createdAt.toDate().dateStringFormat(date: "yyyy/M/d") == info.payload[i-1].createdAt.toDate().dateStringFormat(date: "yyyy/M/d") {
                            vc.sections[sectionCount].items.append(sectionItem)
                        } else {
                            sectionCount += 1
                            vc.sections.append(ChattingSectionModel(items: [SeSACChat(sectionDate: info.payload[i].createdAt.toDate().dateStringFormat(date: "M월 d일 EEEE"))]))
                            vc.sections[sectionCount].items.append(sectionItem)
                        }
                    }
                }
                vc.chat.onNext(vc.sections)
            })
            .disposed(by: disposeBag)
    }
    
    func bindPostInfo() {
        postInfo
            .withUnretained(self)
            .subscribe(onNext: { vc, info in
                vc.sectionItem(item: info.toDomain(dateFormat: "a HH:mm"))
                vc.chat.onNext(vc.sections)
            })
            .disposed(by: disposeBag) 
    }
}
