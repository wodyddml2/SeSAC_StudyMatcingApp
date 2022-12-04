//
//  ShopViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/12.
//
import UIKit
import RxSwift

final class ShopViewController: BaseViewController {

    let mainView = ShopView()
    let viewModel = ShopViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }
    
    override func configureUI() {
        view.backgroundColor = .white
        navigationBarCommon(title: "새싹샵")
        
        let vc = TabmanShopViewController()
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(mainView.safeAreaLayoutGuide)
            make.top.equalTo(mainView.backgroundImageView.snp.bottom)
        }
        vc.didMove(toParent: self)
    }
}

extension ShopViewController {
    private func bindViewModel() {
        let input = ShopViewModel.Input(viewDidLoadEvent: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        mainView.bindImageView(output: output)
    }
}
