//
//  GenderViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import UIKit

import RxSwift

class GenderViewController: BaseViewController {
    
    let mainView = GenderView()
    let viewModel = GenderViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    

}

extension GenderViewController {
    private func bindViewModel() {
        let input = GenderViewModel.Input(
            manButton: mainView.manView.genderButton.rx.tap,
            womanButton: mainView.womanView.genderButton.rx.tap,
            nextButton: mainView.authButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.manButton
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.manView.backgroundColor = .sesacWhiteGreen
                vc.mainView.womanView.backgroundColor = .white
                vc.mainView.authButton.backgroundColor = .sesacGreen
            }
            .disposed(by: disposeBag)
        
        output.womanButton
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.manView.backgroundColor = .white
                vc.mainView.womanView.backgroundColor = .sesacWhiteGreen
                vc.mainView.authButton.backgroundColor = .sesacGreen
            }
            .disposed(by: disposeBag)
        
        output.nextButton
            .withUnretained(self)
            .bind { vc, _ in
                if vc.mainView.authButton.backgroundColor == .sesacGreen {
                    UserManager.gender = vc.mainView.manView.genderButton.backgroundColor == .sesacGreen ? "1" : "0"
                    SeSACAPIService.shared.requestSeSACLogin(router: Router.signUpPost) { result in
                        switch result {
                        case .success(let success):
                            print(success)
                        case .failure(let fail):
                            print(fail)
                        }
                    }
                }
                
            }
            .disposed(by: disposeBag)
        
    }
}
