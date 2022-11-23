//
//  ChattingView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/23.
//

import UIKit

import RxSwift
import RxKeyboard

class ChattingView: BaseView {
    
    let disposeBag = DisposeBag()
    
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
        view.textColor = .gray7
        view.text = "메세지를 입력하세요"
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
    
    func bindKeyboard() {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        let extra = window!.safeAreaInsets.bottom - 32
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive (onNext: { [weak self] height in
                guard let self = self else {return}
                UIView.animate(withDuration: 0) {
                    self.sendButton.setImage(UIImage(named: "act"), for: .normal)
                    self.messageTextView.snp.updateConstraints { make in
                        make.bottom.equalTo(self.safeAreaLayoutGuide).inset(height - extra)
                    }
                }
                self.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.didScroll
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { vc, _ in
                self.endEditing(true)
                self.sendButton.setImage(UIImage(named: "inact"), for: .normal)
                vc.messageTextView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.safeAreaLayoutGuide).inset(30)
                }
                
                UIView.animate(withDuration: 0) {
                    vc.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindTextViewPlaceholder() {
        messageTextView.rx.didBeginEditing
            .withUnretained(self)
            .bind { vc, _ in
                if vc.messageTextView.textColor == .gray7 {
                    vc.messageTextView.text = nil
                    vc.messageTextView.textColor = .black
                }
            }
            .disposed(by: disposeBag)
        
        messageTextView.rx.didEndEditing
            .withUnretained(self)
            .bind { vc, _ in
                if vc.messageTextView.text == "" {
                    vc.messageTextView.text = "메세지를 입력하세요"
                    vc.messageTextView.textColor = .gray7
                }
            }
            .disposed(by: disposeBag)
    }
}
