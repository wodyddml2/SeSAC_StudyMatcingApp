//
//  ChattingViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/12.
//

import UIKit

import RxSwift
import RxDataSources
import RealmSwift

final class ChattingViewController: BaseViewController {

    private let mainView = ChattingView()
    private let viewModel = ChattingViewModel()
    private let disposeBag = DisposeBag()

    private var dataSources: RxTableViewSectionedReloadDataSource<ChattingSectionModel>?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        navigationBarStyle()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ChattingSocketService.shared.closeConnection()
        viewModel.addChats()
    }
   
    @objc func getMessage(notification: NSNotification) {

        let chat = notification.userInfo!["chat"] as! String
        let otherId = notification.userInfo!["otherId"] as! String
        let userId = notification.userInfo!["userId"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
  
        let sesacChat = SeSACChat(
            message: chat,
            createdAt: createdAt.toDate().dateStringFormat(date: "a HH:mm"),
            sectionDate: createdAt.toDate().dateStringFormat(date: "M월 d일 EEEE"),
            from: userId,
            uid: otherId,
            originCreated: createdAt
        )
        viewModel.sectionItem(item: sesacChat)
        
        viewModel.chat.onNext(viewModel.sections)
        
        viewModel.addChat(item: sesacChat)
   }
    
}

extension ChattingViewController {
    private func navigationBarStyle() {
        navigationBarCommon(title: "")
        tabBarAndNaviHidden(hidden: true)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = mainView.backButton
        navigationItem.rightBarButtonItem = mainView.editButton
    }
    
    private func setTableView(uid: String, nick: String) {
        dataSources = RxTableViewSectionedReloadDataSource<ChattingSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            if indexPath.row == 0 {
                guard let dateCell = tableView.dequeueReusableCell(withIdentifier: ChattingDateTableViewCell.reusableIdentifier, for: indexPath) as? ChattingDateTableViewCell else {return UITableViewCell()}
                dateCell.dateLabel.text = item.sectionDate
                dateCell.sectionSet(index: indexPath.section, text: nick)
                
                return dateCell
            } else {
                if uid == item.uid {
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
    
    func scrollToBottom() {
        let sectionCount = viewModel.sections.count - 1
        if sectionCount >= 0 {
            mainView.tableView.scrollToRow(at: IndexPath(row: viewModel.sections[sectionCount].items.count - 1, section: sectionCount), at: .bottom, animated: false)
        }
    }
}

extension ChattingViewController {
    private func bindViewModel() {
        let input = ChattingViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            backButton: mainView.backButton.rx.tap,
            declarationTap: mainView.declarationButton.rx.tap,
            sendTap: mainView.sendButton.rx.tap
        )
        let output = viewModel.transform(input: input)

        mainView.bindKeyboard()
        mainView.bindTextView()
        mainView.bindMenuBar()
        
        bindInfo(output: output)
        bindFailed(output: output)
        bindButtonTapped(output: output)
    }
    
    private func bindDataSource() {
        viewModel.chat
            .bind(to: mainView.tableView.rx.items(dataSource: dataSources!))
            .disposed(by: disposeBag)
    }
    
    private func bindInfo(output: ChattingViewModel.Output) {
        
        output.matchInfo
            .withUnretained(self)
            .subscribe (onNext: { vc, info in
                vc.viewModel.uid = info.matchedUid ?? ""
                vc.viewModel.requestChatGet(lastchatDate: "2000-01-01T00:00:00.000Z")
                guard let nick = info.matchedNick else {return}
                vc.navigationItem.title = nick
                vc.setTableView(uid: info.matchedUid ?? "", nick: nick)
                vc.bindDataSource()
            })
            .disposed(by: disposeBag)
        
        viewModel.bindChatInfo()
        viewModel.bindPostInfo { [weak self] in
            guard let self = self else {return}
            
            self.scrollToBottom()
        }
    }
    
    private func bindFailed(output: ChattingViewModel.Output) {
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
    }

    private func bindButtonTapped(output: ChattingViewModel.Output) {
        output.backButton
            .withUnretained(self)
            .bind { vc, _ in
                vc.navigationPopToViewController(HomeViewController())
            }
            .disposed(by: disposeBag)
        
        output.declarationTap
            .withUnretained(self)
            .bind { vc, _ in
                let viewController = SeSACReviewViewController()
                vc.transition(viewController, transitionStyle: .presentOverFull)
            }
            .disposed(by: disposeBag)
        
        output.sendTap
            .withUnretained(self)
            .bind { vc, _ in
                vc.viewModel.requestChatPost(chat: vc.mainView.messageTextView.text)
                vc.scrollToBottom()
            }
            .disposed(by: disposeBag)
    }
    
}

extension ChattingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return indexPath.section == 0 ? 110 : 60
        } else {
            return UITableView.automaticDimension
        }
    }
}
