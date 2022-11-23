//
//  ChattingView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/23.
//

import UIKit

class ChattingView: BaseView {
    
    let backButton = UIBarButtonItem(image: UIImage(named: "arrow")!, style: .plain, target: ChattingViewController.self, action: nil)
    
    let editButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: ChattingViewController.self, action: nil)
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(MyChatTableViewCell.self, forCellReuseIdentifier: MyChatTableViewCell.reusableIdentifier)
        view.register(YourChatTableViewCell.self, forCellReuseIdentifier: YourChatTableViewCell.reusableIdentifier)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let messageView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray1
        view.makeCornerStyle(radius: 8)
        return view
    }()
    
    let messageTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .gray1
        view.isScrollEnabled = false
        return view
    }()
    
    let sendButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "inact"), for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        [tableView, messageView, messageTextView, sendButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.leading.equalTo(28)
            make.trailing.equalToSuperview().inset(60)
            make.height.lessThanOrEqualTo(58)
        }

        messageView.snp.makeConstraints { make in
            make.trailing.equalTo(messageTextView.snp.trailing).offset(44)
            make.leading.equalTo(messageTextView.snp.leading).offset(-12)
            make.top.equalTo(messageTextView.snp.top).offset(-12)
            make.bottom.equalTo(messageTextView.snp.bottom).offset(12)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(messageView.snp.centerY)
            make.trailing.equalTo(messageView.snp.trailing).inset(12)
            make.height.width.equalTo(24)
        }
    }
}
