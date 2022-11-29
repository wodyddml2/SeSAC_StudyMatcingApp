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
    private var tasks: Results<ChatListData>?
    
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
                self.addChat(item: success.toDomain(dateFormat: "a HH:mm"))
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
                vc.tasks = vc.repository.fetch()
//                vc.sections = vc.tasks
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

extension ChattingViewModel {
    
    func dataChatItems(chat: List<ChatData>) {
        
        var dateFormat: String = ""
        
        if Date().nowDateFormat(date: "yyyy/M/d") == chat[0].createdAt.toDate().dateStringFormat(date: "yyyy/M/d") {
            dateFormat = "a HH:mm"
        } else {
            dateFormat = "M/d a HH:mm"
        }
        
        chat
    }
    
    func fetchChat(list: Results<ChatListData>) {
        var sectionCount = 0
        for i in 0...list.count - 1 {
            let sectionItem = dataChatItems(chat: list[i].chatInfo)
            
//            if i == 0 {
//                vc.sections.append(ChattingSectionModel(items: [SeSACChat(sectionDate: info.payload[i].createdAt.toDate().dateStringFormat(date: "M월 d일 EEEE"))]))
//                vc.sections[sectionCount].items.append(sectionItem)
//            } else {
//                if info.payload[i].createdAt.toDate().dateStringFormat(date: "yyyy/M/d") == info.payload[i-1].createdAt.toDate().dateStringFormat(date: "yyyy/M/d") {
//                    vc.sections[sectionCount].items.append(sectionItem)
//                } else {
//                    sectionCount += 1
//                    vc.sections.append(ChattingSectionModel(items: [SeSACChat(sectionDate: info.payload[i].createdAt.toDate().dateStringFormat(date: "M월 d일 EEEE"))]))
//                    vc.sections[sectionCount].items.append(sectionItem)
//                }
//            }
        }
//        vc.chat.onNext(vc.sections)
    }
    
    
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
                        vc.sections.append(ChattingSectionModel(items: [sectionItem]))
                        vc.sections[sectionCount].items.append(sectionItem)
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
                vc.chat.onNext(vc.sections)
            })
            .disposed(by: disposeBag)
    }
    
    func bindPostInfo(completion: @escaping() -> Void) {
        postInfo
            .withUnretained(self)
            .subscribe(onNext: { vc, info in
                vc.sectionItem(item: info.toDomain(dateFormat: "a HH:mm"))
                vc.chat.onNext(vc.sections)
                completion()
            })
            .disposed(by: disposeBag) 
    }
}

extension ChattingViewModel {
    func addChats() {
        do {
            try repository.deleteRealm()
        } catch {
            print("ss")
        }

        for section in sections {
            let task = ChatListData()
            for item in section.items {
                task.chatInfo.append(ChatData(message: item.message, createdAt: item.createdAt, sectionDate: item.sectionDate, from: item.from, uid: item.uid, originCreated: item.originCreated))
            }
            do {
                try repository.addRealm(item: task)
            } catch {
                print("ee")
            }
        }
    }
    
    func addChat(item: SeSACChat) {
        guard let tasks = tasks else {return}
        
        let outSectionCount = tasks.count - 1
        let inSectionCount = tasks[outSectionCount].chatInfo.count - 1
        
        let task = ChatListData()
        let chat = ChatData(message: item.message, createdAt: item.createdAt, sectionDate: item.sectionDate, from: item.from, uid: item.uid, originCreated: item.originCreated)
        if tasks.isEmpty {
            for _ in 0...1 {
                task.chatInfo.append(chat)
            }
            
            do {
                try repository.addRealm(item: task)
            } catch {
                print("SSSSSS")
            }
        } else {
            if Date().nowDateFormat(date: "M월 d일 EEEE") == tasks[outSectionCount].chatInfo[inSectionCount].sectionDate {
                do {
                    try repository.appendChat(list: tasks[outSectionCount], item: chat)
                } catch {
                    print("SSs")
                }
            } else {
                for _ in 0...1 {
                    task.chatInfo.append(chat)
                }
                
                do {
                    try repository.addRealm(item: task)
                } catch {
                    print("SSSSSS")
                }
            }
        }
    }
}
