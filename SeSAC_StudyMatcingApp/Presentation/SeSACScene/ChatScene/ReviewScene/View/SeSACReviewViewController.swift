//
//  ReviewViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/25.
//

import UIKit

import RxSwift

class SeSACReviewViewController: UIViewController {

    let mainView = SeSACReviewView()
    let viewModel = SeSACReviewViewModel()
    let disposeBag = DisposeBag()
 
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.5)
        mainView.introLabel.text = "\(viewModel.nick)님과의 스터디는 어떠셨나요?"
        bindTo()
    }
    
    func bindTo() {
        let input = SeSACReviewViewModel.Input(
            manner: mainView.stackView.mannerButton.rx.tap,
            promise: mainView.stackView.promiseButton.rx.tap,
            fast: mainView.stackView.fastButton.rx.tap,
            kind: mainView.stackView.kindButton.rx.tap,
            skill: mainView.stackView.skillButton.rx.tap,
            beneficial: mainView.stackView.beneficialButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.success
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] success in
                guard let self = self else {return}
                if success == true {
                    self.dismiss(animated: false) {
                        guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                        vc.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }).disposed(by: disposeBag)
        
        output.networkFailed
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] error in
                guard let self = self else {return}
                if error == true {
                    self.view.makeToast("사용자의 정보를 불러오는데 실패했습니다.", position: .center)
                }
            }).disposed(by: disposeBag)
        
        mainView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
        
        output.reviewButton
            .withUnretained(self)
            .bind { vc, review in
                switch review {
                case .manner:
                    vc.mainView.selectedAction(button: vc.mainView.stackView.mannerButton)
                case .promise:
                    vc.mainView.selectedAction(button: vc.mainView.stackView.promiseButton)
                case .fast:
                    vc.mainView.selectedAction(button: vc.mainView.stackView.fastButton)
                case .kind:
                    vc.mainView.selectedAction(button: vc.mainView.stackView.kindButton)
                case .skill:
                    vc.mainView.selectedAction(button: vc.mainView.stackView.skillButton)
                case .beneficial:
                    vc.mainView.selectedAction(button: vc.mainView.stackView.beneficialButton)
                }
            }
            .disposed(by: disposeBag)
        

        
        mainView.okButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                if vc.mainView.reviewButtonList.contains(1) {
                    if vc.mainView.contentsTextView.text.count <= 500 {
                        vc.viewModel.requestRate(output: output, list: vc.mainView.reviewButtonList, comment: vc.mainView.contentsTextView.text)
                    } else {
                        vc.mainView.makeToast("리뷰는 500자 이상 불가능해요!", position: .center)
                    }
                } else {
                    vc.mainView.makeToast("리뷰 항목 한 가지 이상 선택해주세요!", position: .center)
                }
            }
            .disposed(by: disposeBag)

    }

}
