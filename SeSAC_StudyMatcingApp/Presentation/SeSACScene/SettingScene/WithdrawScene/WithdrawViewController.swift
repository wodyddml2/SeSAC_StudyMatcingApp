//
//  WithdrawViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/16.
//

import UIKit

import FirebaseAuth
import RxSwift

class WithdrawViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "정말 탈퇴하시겠습니까?"
        view.font = UIFont.notoSans(size: 16, family: .Medium)
        view.textAlignment = .center
        return view
    }()
    
    let subTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ"
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        view.textAlignment = .center
        return view
    }()
    
    let cancelButton: CommonButton = {
        let view = CommonButton()
        view.normalStyle()
        view.setTitle("취소", for: .normal)
        return view
    }()
    
    let okButton: CommonButton = {
        let view = CommonButton()
        view.selectedStyle()
        view.setTitle("확인", for: .normal)
        return view
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.5)
        bindTo()
    }
    
    override func configureUI() {
        view.addSubview(popupView)
        
        [titleLabel, subTitleLabel, cancelButton, okButton].forEach {
            popupView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.19)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(view.snp.centerX).offset(-4)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        okButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(view.snp.centerX).offset(4)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    func bindTo() {
        cancelButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
        
        okButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.requestWithdraw()
            }
            .disposed(by: disposeBag)
    }
    
    func requestWithdraw() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else {return}
            if error != nil {
                print("error")
            }
            if let idToken = idToken {
                UserManager.idToken = idToken
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                SeSACAPIService.shared.requestSeSACAPI(type: SESACLoginDTO.self,router: Router.withdrawPost(query: UserManager.idToken)) { result in
                    switch result {
                    case .success(_):
                        print("성공을 안타")
                    case .failure(let fail):
                        let error = fail as! SeSACError
                        switch error {
                        case .success, .existingUsers:
                            UserManager.onboarding = false
                            
                            let vc = OnboardingViewController()
                            sceneDelegate?.window?.rootViewController = vc
                            sceneDelegate?.window?.makeKeyAndVisible()
                        default:
                            self.dismiss(animated: false)
                            guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                            viewController.view.makeToast("응 못나가~", position: .center)
                        }
                    }
                }
            }
        }
        
    }
    
  
}
