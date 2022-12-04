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
    
    let viewController = TabmanShopViewController()
    
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
        
        
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(mainView.safeAreaLayoutGuide)
            make.top.equalTo(mainView.backgroundImageView.snp.bottom)
        }
        viewController.didMove(toParent: self)
    }
}

extension ShopViewController {
    private func bindViewModel() {
        let input = ShopViewModel.Input(viewDidLoadEvent: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        mainView.bindImageView(output: output)
        
        output.myInfo
            .withUnretained(self)
            .subscribe { vc, result in
                vc.mainView.backgroundImageView.image = .sesacBackgroundImage(num: result.background)
                vc.mainView.sesacImageView.image = .sesacImage(num: result.sesac)
                vc.viewController.firstVC.viewModel.sesacCollection.onNext(result.sesacCollection)
            }
            .disposed(by: disposeBag)
        
        viewController.firstVC.collectionView.rx.itemSelected
            .withUnretained(self)
            .bind { vc, indexPath in
                vc.mainView.sesacImageView.image = .sesacImage(num: indexPath.item)
            }
            .disposed(by: disposeBag)
        
    }
}
