//
//  ShopViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/12.
//
import UIKit

final class ShopViewController: BaseViewController {

    let mainView = ShopView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let vc = TabmanShopViewController()
        navigationBarCommon(title: "새싹샵")
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
