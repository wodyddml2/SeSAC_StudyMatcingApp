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
import RealmSwift

class ChattingViewModel {
    
    let disposeBag = DisposeBag()
    let repository = ChatRepository()
    var tasks: Results<ChatListData>?
    
    var chatInfo = PublishSubject<SeSACChatGetDTO>()
    var postInfo = PublishSubject<SeSACChatPostDTO>()
    var postFailed = PublishRelay<Bool>()
    var getFailed = PublishRelay<Bool>()
    var scrollTo = PublishRelay<Bool>()
    
    var chat = PublishSubject<[ChattingSectionModel]>()
    var sections: [ChattingSectionModel] = []
    
    var uid: String = ""
    var nickname: String = ""
    var lastDate: Date = Date()
    
    func requestMyQueue(output: Output) {
        SeSACAPIService.shared.requestSeSACAPI(type: SeSACMatchDTO.self, router: QueueRouter.match(query: UserManager.idToken)) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                output.matchInfo.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    self.renwalGetIdToken { [weak self] in
                        guard let self = self else {return}
                        self.requestMyQueue(output: output)
                    }
                default:
                    output.networkFailed.accept(true)
                }
            }
        }
    }

    func requestChatPost(chat: String) {
        ChattingAPIService.shared.requestPOSTAPI(router: ChatRouter.chatPost(query: UserManager.idToken, path: uid, chat: chat)) { [weak self] result in
            
            guard let self = self else {return}
            switch result {
            case .success(let success):
                self.postInfo.onNext(success)
                self.addChat(item: success.toDomain(dateFormat: "a HH:mm"))
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    self.renwalGetIdToken { [weak self] in
                        guard let self = self else {return}
                        self.requestChatPost(chat: chat)
                    }
                default:
                    self.postFailed.accept(true)
                }
            }
        }
    }
    
    func requestChatGet(lastchatDate: String) {
        ChattingAPIService.shared.requestGETAPI(router: ChatRouter.chatGet(query: UserManager.idToken, path: uid, lastchatDate: lastchatDate)) { [weak self] result in
            
            guard let self = self else {return}
            switch result {
            case .success(let success):
                self.chatInfo.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenError:
                    self.renwalGetIdToken { [weak self] in
                        guard let self = self else {return}
                        self.requestChatGet(lastchatDate: lastchatDate)
                    }
                default:
                    self.getFailed.accept(true)
                }
            }
        }
    }
}

extension ChattingViewModel: ViewModelType {
    struct Input {
        let backButton: ControlEvent<Void>
        let declarationTap: ControlEvent<Void>
        let cancelTap: ControlEvent<Void>
        let reviewTap: ControlEvent<Void>
        let sendTap: ControlEvent<Void>
    }
    
    struct Output {
        var matchInfo = PublishSubject<SeSACMatchDTO>()
        var networkFailed = PublishRelay<Bool>()
        let backButton: ControlEvent<Void>
        let declarationTap: ControlEvent<Void>
        let cancelTap: ControlEvent<Void>
        let reviewTap: ControlEvent<Void>
        let sendTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            backButton: input.backButton,
            declarationTap: input.declarationTap,
            cancelTap: input.cancelTap,
            reviewTap: input.reviewTap,
            sendTap: input.sendTap
        )
        
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
            uid: payload.to,
            originCreated: payload.createdAt
        )
    }
    
    func sectionItem(item: SeSACChat) {
 
        if sections.isEmpty {
            sections.append(ChattingSectionModel(items: [item, item]))
        } else {
            var sectionCount = sections.isEmpty ? 0 : sections.count - 1
            let rowCount = sections[sectionCount].items.count - 1
            if sections[sectionCount].items[rowCount].sectionDate == item.sectionDate {
                sections[sectionCount].items.append(item)
            } else {
                sectionCount += 1
                sections.append(ChattingSectionModel(items: [item, item]))
            }
        }
    }
    
    
    func bindChatInfo() {
        chatInfo
            .withUnretained(self)
            .subscribe (onNext: { vc, info in
                var sectionCount = vc.sections.isEmpty ? 0 : vc.sections.count - 1
                if !info.payload.isEmpty {
                    for i in 0...info.payload.count - 1 {
                        let sectionItem = vc.sectionItems(info.payload[i])
                        
                        if vc.tasks?.isEmpty == true {
                            vc.sections.append(ChattingSectionModel(items: [sectionItem]))
                            vc.sections[sectionCount].items.append(sectionItem)
                        } else {
                            if i == 0 {
                                guard let tasks = vc.tasks else {return}
                                if tasks[0].chatInfo[tasks[0].chatInfo.count - 1].createdAt.toDate().dateStringFormat(date: "yyyy/M/d") == info.payload[i].createdAt.toDate().dateStringFormat(date: "yyyy/M/d") {
                                    vc.sections[sectionCount].items.append(sectionItem)
                                } else {
                                    vc.sections.append(ChattingSectionModel(items: [sectionItem]))
                                    vc.sections[sectionCount].items.append(sectionItem)
                                }
                            } else {
                                if info.payload[i].createdAt.toDate().dateStringFormat(date: "yyyy/M/d") == info.payload[i-1].createdAt.toDate().dateStringFormat(date: "yyyy/M/d") {
                                    vc.sections[sectionCount].items.append(sectionItem)
                                } else {
                                    sectionCount += 1
                                    vc.sections.append(ChattingSectionModel(items: [sectionItem]))
                                    vc.sections[sectionCount].items.append(sectionItem)
                                }
                            }
                        }
                        vc.addChat(item: sectionItem)
                    }
                    vc.chat.onNext(vc.sections)
                }
                vc.scrollTo.accept(true)
            })
            .disposed(by: disposeBag)
    }
    
    func bindPostInfo() {
        postInfo
            .withUnretained(self)
            .subscribe(onNext: { vc, info in
                vc.sectionItem(item: info.toDomain(dateFormat: "a HH:mm"))
                vc.chat.onNext(vc.sections)
                vc.scrollTo.accept(true)
            })
            .disposed(by: disposeBag)
    }
}

extension ChattingViewModel {
    
    func chatItems(item: ChatData) -> SeSACChat {
        var dateFormat: String = ""
        if Date().nowDateFormat(date: "yyyy/M/d") == item.createdAt.toDate().dateStringFormat(date: "yyyy/M/d") {
            dateFormat = "a HH:mm"
        } else {
            dateFormat = "M/d a HH:mm"
        }
        return SeSACChat(
            message: item.message,
            createdAt: item.createdAt.toDate().dateStringFormat(date: dateFormat),
            sectionDate: item.createdAt.toDate().dateStringFormat(date: "M월 d일 EEEE"),
            from: item.from,
            uid: item.uid,
            originCreated: item.createdAt
        )
    }
    
    func fetchChat(list: ChatListData) {
        var sectionCount = 0
       
        for i in 0...list.chatInfo.count - 1 {
            let chatItem = chatItems(item: list.chatInfo[i])
            
            if i == 0 {
                sections.append(ChattingSectionModel(items: [chatItem]))
                sections[sectionCount].items.append(chatItem)
            } else {
                if list.chatInfo[i].createdAt.toDate().dateStringFormat(date: "yyyy/M/d") == list.chatInfo[i-1].createdAt.toDate().dateStringFormat(date: "yyyy/M/d") {
                    sections[sectionCount].items.append(chatItem)
                } else {
                    sectionCount += 1
                    sections.append(ChattingSectionModel(items: [chatItem]))
                    sections[sectionCount].items.append(chatItem)
                }
            }
        }
        chat.onNext(sections)
    }
    func requestGetBranch() {
        tasks = repository.fetchFilter(uid: uid)
        if let tasks = tasks {
            if tasks.isEmpty {
                requestChatGet(lastchatDate: "2000-01-01T00:00:00.000Z")
            } else {
                fetchChat(list: tasks[0])
                requestChatGet(lastchatDate: tasks[0].chatInfo[tasks[0].chatInfo.count - 1].createdAt)
            }
        } else {
            requestChatGet(lastchatDate: "2000-01-01T00:00:00.000Z")
        }
    }
    func addChat(item: SeSACChat) {
        guard let tasks = tasks else {return}
        
        let task = ChatListData(uid: uid, chatInfo: List<ChatData>())
        let chat = ChatData(message: item.message, createdAt: item.originCreated, from: item.from, uid: item.uid)
        if tasks.isEmpty {
            task.chatInfo.append(chat)
            do {
                try repository.addRealm(item: task)
            } catch {
                print("error")
            }
        } else {
            do {
                try repository.appendChat(list: tasks[0], item: chat)
            } catch {
                print("error")
            }
        }
    }
}
