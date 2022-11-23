//
//  ChattingViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/12.
//

import UIKit

import RxSwift
import RxDataSources

final class ChattingViewController: BaseViewController {

    let mainView = ChattingView()
    let disposeBag = DisposeBag()
    
    private var dataSources: RxTableViewSectionedReloadDataSource<ChattingSectionModel>?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationBarStyle()
        bindViewModel()
        setTableView()
    }

    private func navigationBarStyle() {
        navigationBarCommon(title: "홍")
        tabBarAndNaviHidden(hidden: true)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = mainView.backButton
        navigationItem.rightBarButtonItem = mainView.editButton
    }
    
    private func setTableView() {
        dataSources = RxTableViewSectionedReloadDataSource<ChattingSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            guard let myCell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.reusableIdentifier, for: indexPath) as? MyChatTableViewCell else {return UITableViewCell()}
            myCell.chatLabel.text = item.message
            return myCell
        })
        let sections: [ChattingSectionModel] = [ChattingSectionModel(items: [SeSACChat(message: "dfsdfsdfsdfsdfsdfsdfsfsfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsfsdfsdfsdfsdfdsfsdfdsfdsfsdfdsfdsfdsfds")])]
 
        let data = Observable<[ChattingSectionModel]>.just(sections)
        
        data
            .bind(to: mainView.tableView.rx.items(dataSource: dataSources!))
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
   
        mainView.backButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.navigationPopToViewController(HomeViewController())
            }
            .disposed(by: disposeBag)
        
        mainView.bindKeyboard()
        mainView.bindTextView()
    }
}

extension ChattingViewController: UITableViewDelegate {
    
}
