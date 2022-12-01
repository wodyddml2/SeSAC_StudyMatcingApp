//
//  CancelViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/25.
//

import UIKit

import FirebaseAuth
import RxSwift

class CancelViewController: BaseViewController {

    let mainView = AlertView()
    let disposeBag = DisposeBag()
    
    var matchingState: Bool = true
    var uid: String = ""
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindTo()
    }
    
    override func configureUI() {
        view.layer.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.5)
        if matchingState {
            mainView.titleText(title: "스터디를 취소하시겠습니까?", subTitle: "스터디를 취소하시면 패널티가 부과됩니다.")
        } else {
            mainView.titleText(title: "스터디를 종료하시겠습니까",
                               subTitle: """
                                상대방이 스터디를 취소했기 때문에
                                패널티가 부과되지 않습니다
                                """)
            mainView.subTitleLabel.numberOfLines = 2
        }
        
        mainView.subTitleLabel.textColor = .gray7
        mainView.cancelButton.backgroundColor = .gray2
        mainView.cancelButton.layer.borderWidth = 0
    }
    
    override func setConstraints() {
        if matchingState {
            mainView.alertView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(156)
            }
        } else {
            mainView.alertView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(180)
            }
        }
        
        mainView.cancelButton.snp.remakeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(mainView.snp.centerX).offset(-4)
            make.height.equalTo(48)
        }
        
        mainView.okButton.snp.remakeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(mainView.snp.centerX).offset(4)
            make.height.equalTo(48)
        }
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
                vc.requestDodge()
            }
            .disposed(by: disposeBag)
    }
    
    private func requestDodge() {
        SeSACAPIService.shared.requestStatusSeSACAPI(router: Router.dodgePost(query: UserManager.idToken, uid: uid)) { [weak self] value in
            guard let self = self else {return}
            switch StatusCode(rawValue: value) {
            case .success:
                self.dismiss(animated: false) {
                    guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                    vc.navigationController?.popToRootViewController(animated: true)
                }
            case .firebaseError:
                self.renwalGetIdToken { [weak self] in
                    guard let self = self else {return}
                    self.requestDodge()
                }
            default:
                self.view.makeToast("에러가 발생했습니다.")
            }
        }
    }
    
//    private func renewalDodge() {
//        let currentUser = Auth.auth().currentUser
//        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
//            guard let self = self else {return}
//            if error != nil {
//                self.view.makeToast("에러가 발생했습니다.")
//                return
//            }
//            if let idToken = idToken {
//                UserManager.idToken = idToken
//                
//                self.requestDodge()
//            }
//        }
//    }
}
