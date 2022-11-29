//
//  PopupViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/22.
//

import UIKit

import RxSwift
import FirebaseAuth

final class PopupViewController: BaseViewController {
    
    let mainView = AlertView()
    let disposeBag = DisposeBag()
    
    var request: Bool = true
    var uid: String?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.5)
        popupCustom()
        bindTo()
    }
    
    override func setConstraints() {
        mainView.alertView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.22)
        }
        
        mainView.cancelButton.snp.remakeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(mainView.snp.centerX).offset(-4)
            make.height.equalToSuperview().multipliedBy(0.26)
        }
        
        mainView.okButton.snp.remakeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(mainView.snp.centerX).offset(4)
            make.height.equalToSuperview().multipliedBy(0.26)
        }
    }
    
    private func popupCustom() {
        if request {
            mainView.titleText(
                title: "스터디를 요청할게요!",
                subTitle:
                        """
                        상대방이 요청을 수락하면
                        채팅창에서 대화를 나눌 수 있어요
                        """
            )
        } else {
            mainView.titleText(title: "스터디를 수락할까요?", subTitle: "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요")
        }
        
        mainView.subTitleLabel.textColor = .gray7
        mainView.cancelButton.backgroundColor = .gray2
        mainView.cancelButton.layer.borderWidth = 0
        
    }
    
    private func bindTo() {
        mainView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
        
        mainView.okButton.rx.tap
            .throttle(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { vc, _ in
                if vc.request {
                    vc.requestPost()
                } else {
                    vc.acceptPost()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func dismissToast(message: String) {
        self.dismiss(animated: false) {
            guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
            vc.view.makeToast(message)
        }
    }
}

extension PopupViewController {
    private func requestPost() {
        guard let uid = uid else {return}
        SeSACAPIService.shared.requestStatusSeSACAPI(router: Router.requestPost(query: UserManager.idToken, uid: uid)) { [weak self] value in
            guard let self = self else {return}
            
            switch StatusCode(rawValue: value) {
            case .success:
                self.dismissToast(message: "스터디 요청을 보냈습니다")
            case .declarationOrMatch:
                self.acceptPost()
            case .stopFind:
                self.dismissToast(message: "상대방이 스터디 찾기를 그만두었습니다")
            case .firebaseError:
                self.renewalRequest()
            default:
                self.view.makeToast("에러가 발생했습니다")
            }
        }
    }
    
    private func renewalRequest() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else {return}
            if error != nil {
                self.view.makeToast("에러가 발생했습니다.")
                return
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                
                self.requestPost()
            }
        }
    }
}

extension PopupViewController {
    private func acceptPost() {
        guard let uid = uid else {
            view.makeToast("에러가 발생했습니다.")
            return}
        SeSACAPIService.shared.requestStatusSeSACAPI(router: Router.acceptPost(query: UserManager.idToken, uid: uid)) { [weak self] value in
            guard let self = self else {return}
            switch StatusCode(rawValue: value) {
            case .success:
                NotificationCenter.default.post(name: NSNotification.Name("dispose"), object: self)
                self.dismiss(animated: false) { [weak self] in
                    guard let self = self else {return}
                    if self.request {
                        guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                        vc.view.makeToast(MatchComment.togetherMatch, duration: 1) { _ in
                            self.requestMYQueue { result in
                                let chatting = ChattingViewController()
                                chatting.viewModel.uid = result.matchedUid ?? ""
                                chatting.viewModel.nickname = result.matchedNick ?? ""
                                vc.transition(chatting, transitionStyle: .push)
                            }
                        }
                    } else {
                        guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                        self.requestMYQueue { result in
                            let chatting = ChattingViewController()
                            chatting.viewModel.uid = result.matchedUid ?? ""
                            chatting.viewModel.nickname = result.matchedNick ?? ""
                            vc.transition(chatting, transitionStyle: .push)
                        }
                    }
                }
                // 사용자 현재 상태를 매칭 상태로 변경하고, 팝업 화면을 dismiss 한 뒤, 채팅 화면(1_5_chatting)으로 화면을 전환합니다.
            case .declarationOrMatch:
                self.dismissToast(message: "상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다")
            case .stopFind:
                self.dismissToast(message: "상대방이 스터디 찾기를 그만두었습니다")
            case .cancelFirst:
                self.dismissToast(message: "앗! 누군가가 나의 스터디를 수락하였어요!")
            case .firebaseError:
                self.renewalAccpet()
            default:
                self.view.makeToast("에러가 발생했습니다")
            }
        }
    }
    
    private func renewalAccpet() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else {return}
            if error != nil {
                self.view.makeToast("에러가 발생했습니다.")
                return
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                
                self.acceptPost()
            }
        }
    }
    
    func requestMYQueue(completion: @escaping (SeSACMatchDTO) -> Void) {
        SeSACAPIService.shared.requestSeSACAPI(type: SeSACMatchDTO.self, router: Router.matchGet(query: UserManager.idToken)) { result in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(_):
                print("Ssss")
                }
            }
        }
}
