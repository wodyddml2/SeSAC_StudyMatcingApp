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
                if UserManager.myUid == item.uid {
                    guard let myCell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.reusableIdentifier, for: indexPath) as? MyChatTableViewCell else {return UITableViewCell()}
                    myCell.chatLabel.text = item.message
                    myCell.timeLabel.text = item.createdAt
                    return myCell
                } else {
                    guard let yourCell = tableView.dequeueReusableCell(withIdentifier: YourChatTableViewCell.reusableIdentifier, for: indexPath) as? YourChatTableViewCell else {return UITableViewCell()}
                    yourCell.chatLabel.text = item.message
                    yourCell.timeLabel.text = item.createdAt
                    return yourCell
                }
               
            }
        })
 
        mainView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    private func bindDataSource(chat: [ChattingSectionModel]) {
        Observable<[ChattingSectionModel]>.just(chat)
            .bind(to: mainView.tableView.rx.items(dataSource: dataSources!))
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
        
        viewModel.chat.subscribe { chat in
            self.bindDataSource(chat: chat)
        }.disposed(by: disposeBag)
        
        output.matchInfo
            .withUnretained(self)
            .subscribe (onNext: { vc, info in
                vc.viewModel.uid = info.matchedUid ?? ""
                vc.viewModel.requestChatGet(lastchatDate: "2000-01-01T00:00:00.000Z")
                guard let nick = info.matchedNick else {return}
                vc.navigationItem.title = nick // 늦게 뜸 시점;;
                
            })
            .disposed(by: disposeBag)
        
        viewModel.chatInfo
            .withUnretained(self)
            .subscribe (onNext: { vc, info in 
                info.payload.forEach { list in
                    vc.viewModel.sections[0].items.append(SeSACChat(message:  list.chat, createdAt: list.createdAt.toDate().dateStringFormat(), uid: list.from))
                }
                
                vc.viewModel.chat.onNext(vc.viewModel.sections)
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
        
        viewModel.postFailed
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] error in
                guard let self = self else {return}
                if error == true {
                    self.view.makeToast("상대방에게 채팅을 보낼 수 없습니다", position: .center)
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
        
        mainView.declarationButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                let viewController = SeSACReviewViewController()
                vc.transition(viewController, transitionStyle: .presentOverFull)
            }
            .disposed(by: disposeBag)
        
        mainView.sendButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.viewModel.requestChatPost(chat: vc.mainView.messageTextView.text)
            }
            .disposed(by: disposeBag)
    }
}

extension ChattingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 110
        } else {
            return UITableView.automaticDimension
        }
    }
}
