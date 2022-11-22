//
//  SeSACFindView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/21.
//

import UIKit

class SeSACFindView: BaseView {
    let tableView: UITableView = {
        let view = UITableView()
        view.register(SeSACFindImageTableViewCell.self, forCellReuseIdentifier: SeSACFindImageTableViewCell.reusableIdentifier)
        view.register(SeSACFindReviewTableViewCell.self, forCellReuseIdentifier: SeSACFindReviewTableViewCell.reusableIdentifier)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let sesacImageView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "noSesac")
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.font = UIFont.notoSans(size: 20, family: .Regular)
        view.textAlignment = .center
        return view
    }()
    
    let subTitleLabel: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        view.textAlignment = .center
        view.textColor = .gray7
        view.text = "스터디를 변경하거나 조금만 더 기다려 주세요!"
        return view
    }()
    
    let changeButton: CommonButton = {
        let view = CommonButton()
        view.isHidden = true
        view.selectedStyle()
        view.setTitle("스터디 변경하기", for: .normal)
        return view
    }()
    
    let reloadButton: CommonButton = {
        let view = CommonButton()
        view.isHidden = true
        view.outlineStyle()
        view.setImage(UIImage(named: "reload"), for: .normal)
        return view
    }()
    
    let refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.backgroundColor = .white
        view.tintColor = .sesacGreen
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.refreshControl = refreshControl
    }
    
    override func configureUI() {
        [tableView, sesacImageView, titleLabel, subTitleLabel, changeButton, reloadButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(44)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.centerY.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(sesacImageView.snp.bottom).offset(32)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        changeButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(reloadButton.snp.leading).offset(-8)
        }
        
        
        reloadButton.snp.makeConstraints { make in
            make.height.width.equalTo(changeButton.snp.height)
            make.centerY.equalTo(changeButton.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
        }
        
    }
}
