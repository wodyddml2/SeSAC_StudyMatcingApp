//
//  ChattingView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/23.
//

import UIKit

import RxSwift
import RxKeyboard
import RxGesture

class ChattingView: BaseView {
    
    let disposeBag = DisposeBag()
    
    let backButton = UIBarButtonItem(image: UIImage(named: "arrow")!, style: .plain, target: ChattingViewController.self, action: nil)
    
    let editButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: ChattingViewController.self, action: nil)
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(MyChatTableViewCell.self, forCellReuseIdentifier: MyChatTableViewCell.reusableIdentifier)
        view.register(YourChatTableViewCell.self, forCellReuseIdentifier: YourChatTableViewCell.reusableIdentifier)
        view.register(ChattingDateTableViewCell.self, forCellReuseIdentifier: ChattingDateTableViewCell.reusableIdentifier)
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
    
    let menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let blurView: UIButton = {
        let view = UIButton()
        view.layer.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.5)
        return view
    }()
    
    lazy var declarationButton: UIButton = {
        let view = UIButton()
        view.configuration = buttonCofigure(image: ChatMenuImage.siren.image, title: "새싹 신고")
        view.tintColor = .black
        return view
    }()
    
    lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.configuration = buttonCofigure(image: ChatMenuImage.cancel.image, title: "스터디 취소")
        view.tintColor = .black
        return view
    }()
    
    lazy var writeButton: UIButton = {
        let view = UIButton()
        view.configuration = buttonCofigure(image: ChatMenuImage.write.image, title: "리뷰 등록")
        view.tintColor = .black
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [declarationButton, cancelButton, writeButton])
        view.alignment = .fill
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func buttonCofigure(image: UIImage?, title: String) -> UIButton.Configuration  {
        var config = UIButton.Configuration.plain()
        config.image = image
        config.imagePlacement = .top
        config.imagePadding = 4
        var titleAttr = AttributedString.init(title)
        titleAttr.font = .notoSans(size: 14, family: .Medium)
        config.attributedTitle = titleAttr
        return config
    }
    
    override func configureUI() {
        [tableView, messageView, messageTextView, sendButton, blurView].forEach {
            self.addSubview($0)
        }
        
        blurView.addSubview(menuView)
        menuView.addSubview(stackView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(messageTextView.snp.top).offset(-12)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.leading.equalTo(28)
            make.trailing.equalToSuperview().inset(60)
            make.height.lessThanOrEqualTo(48)
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
        
        blurView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(0)
        }
        menuView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(blurView)
            make.height.equalTo(0)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(menuView)
        }
    }
}

extension ChattingView {
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
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        self.tableView.scrollToRow(at: IndexPath(row: 5, section: 0), at: .bottom, animated: true)
//                    }
                }
                self.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.tapGesture()
            .when(.recognized)
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
    
    func bindTextView() {
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
        
        messageTextView.rx.didChange
            .withUnretained(self)
            .bind { vc, _ in
                let size = CGSize(width: vc.messageTextView.frame.width, height: .infinity)
                // sizeThatFits -> 지정된 크기를 계산하고 반환
                let estimatedSize = vc.messageTextView.sizeThatFits(size)
                let isOverHeight = estimatedSize.height >= 48

                vc.messageTextView.isScrollEnabled = isOverHeight
                vc.setNeedsUpdateConstraints()
            }
            .disposed(by: disposeBag)
    }
    
    func bindMenuBar() {
        editButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.menuView.snp.remakeConstraints { make in
                    make.top.leading.trailing.equalTo(vc.blurView)
                    make.height.equalTo(72)
                }
                UIView.animate(withDuration: 0.3) {
                    vc.layoutIfNeeded()

                    vc.blurView.snp.remakeConstraints { make in
                        make.top.leading.trailing.equalTo(vc.safeAreaLayoutGuide)
                        make.bottom.equalToSuperview()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        vc.stackView.isHidden = false
                    }
                }
            }
            .disposed(by: disposeBag)
        
        blurView.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.stackView.isHidden = true
                vc.menuView.snp.remakeConstraints { make in
                    make.top.leading.trailing.equalTo(vc.blurView)
                    make.height.equalTo(0)
                }
                vc.blurView.snp.remakeConstraints { make in
                    make.top.leading.trailing.equalTo(vc.safeAreaLayoutGuide)
                    make.height.equalTo(0)
                }
            }
            .disposed(by: disposeBag)
    }
}
