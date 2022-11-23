//
//  ChattingViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/12.
//

import UIKit

import RxSwift

final class ChattingViewController: BaseViewController {
    
    let backButton = UIBarButtonItem(image: UIImage(named: "arrow")!, style: .plain, target: ChattingViewController.self, action: nil)
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .errorRed
        navigationBarStyle()
        bindViewModel()
    }
    
    private func navigationBarStyle() {
        navigationBarCommon(title: "ss")
        tabBarAndNaviHidden(hidden: true)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }

    private func bindViewModel() {
        backButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.navigationPopToViewController(HomeViewController())
            }
            .disposed(by: disposeBag)
    }

}
