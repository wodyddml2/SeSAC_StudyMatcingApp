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
    let viewModel = ChattingViewModel()
    let disposeBag = DisposeBag()
  
    private var dataSources: RxTableViewSectionedReloadDataSource<ChattingSectionModel>?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setTableView()
        navigationBarStyle()
    }

    private func navigationBarStyle() {
        navigationBarCommon(title: "")
        tabBarAndNaviHidden(hidden: true)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = mainView.backButton
        navigationItem.rightBarButtonItem = mainView.editButton
    }
    
    private func setTableView() {
        dataSources = RxTableViewSectionedReloadDataSource<ChattingSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            if indexPath.row == 0 {
                guard let dateCell = tableView.dequeueReusableCell(withIdentifier: ChattingDateTableViewCell.reusableIdentifier, for: indexPath) as? ChattingDateTableViewCell else {return UITableViewCell()}
                
                return dateCell
            } else {
                guard let myCell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.reusableIdentifier, for: indexPath) as? MyChatTableViewCell else {return UITableViewCell()}
                myCell.chatLabel.text = item.message
                return myCell
            }
        })
        let sections: [ChattingSectionModel] = [ChattingSectionModel(items: [SeSACChat(), SeSACChat(message: "새벽반 모집 새벽반 모집 새벽반 모집 새벽반 모집 새벽반 모집 새벽반 모집 새벽반 모집 새벽반 모집 새벽반 모집 새벽반 모집 새벽반 모집")])]
 
        let data = Observable<[ChattingSectionModel]>.just(sections)
        
        data
            .bind(to: mainView.tableView.rx.items(dataSource: dataSources!))
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension ChattingViewController {
    private func bindViewModel() {
        
        let input = ChattingViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            backButton: mainView.backButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.matchInfo
            .withUnretained(self)
            .subscribe (onNext: { vc, info in
                guard let nick = info.matchedNick else {return}
                vc.navigationItem.title = nick // 늦게 뜸 시점;;
            })
            .disposed(by: disposeBag)
        
        output.networkFailed
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] error in
                guard let self = self else {return}
                if error == true {
                    self.view.makeToast("사용자의 정보를 불러오는데 실패했습니다.")
                }
            }).disposed(by: disposeBag)
    
        output.backButton
            .withUnretained(self)
            .bind { vc, _ in
                vc.navigationPopToViewController(HomeViewController())
            }
            .disposed(by: disposeBag)
        
        mainView.bindKeyboard()
        mainView.bindTextView()
        mainView.bindMenuBar()
    }
}

extension ChattingViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 110
        } else {
            return UITableView.automaticDimension
        }
    }
}
