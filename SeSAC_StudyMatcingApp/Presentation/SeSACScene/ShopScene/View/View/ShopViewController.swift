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
                vc.mainView.backgroundImageView.tag = result.background
                vc.mainView.sesacImageView.tag = result.sesac
                vc.viewController.firstVC.viewModel.sesacArr = result.sesacCollection
                vc.viewController.secondVC.viewModel.sesacArr = result.backgroundCollection
            }
            .disposed(by: disposeBag)
        
       
        viewController.firstVC.collectionView.rx.itemSelected
            .withUnretained(self)
            .bind { vc, indexPath in
                vc.mainView.sesacImageView.image = .sesacImage(num: indexPath.item)
                vc.mainView.sesacImageView.tag = indexPath.item
            }
            .disposed(by: disposeBag)
        
        viewController.secondVC.tableView.rx.itemSelected
            .withUnretained(self)
            .bind { vc, indexPath in
                vc.mainView.backgroundImageView.image = .sesacBackgroundImage(num: indexPath.row)
                vc.mainView.backgroundImageView.tag = indexPath.row
            }
            .disposed(by: disposeBag)
        
        mainView.saveButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { vc, _ in
                vc.viewModel.requestItem(output: output, sesac: vc.mainView.sesacImageView.tag, background: vc.mainView.backgroundImageView.tag)
            }
            .disposed(by: disposeBag)
        
    }
}
