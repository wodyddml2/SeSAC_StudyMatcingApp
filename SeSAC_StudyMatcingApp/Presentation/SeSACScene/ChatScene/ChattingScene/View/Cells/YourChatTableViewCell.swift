//
//  YourChatTableViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/23.
//

import UIKit

final class YourChatTableViewCell: BaseTableViewCell {

    let chatView: UIView = {
        let view = UIView()
        view.makeCornerStyle(radius: 8)
        view.backgroundColor = .sesacWhiteGreen
        return view
    }()
    
    let chatLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        return view
    }()
    
    let timeLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.notoSans(size: 12, family: .Regular)
        view.textColor = .gray6
        view.text = "15:02"
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureUI() {
        [chatView, chatLabel, timeLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        chatLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-32)
            make.top.bottom.equalToSuperview().inset(22)
            make.leading.greaterThanOrEqualToSuperview().offset(110)
        }
        
        chatView.snp.makeConstraints { make in
            make.leading.equalTo(chatLabel.snp.leading).offset(-16)
            make.trailing.equalTo(chatLabel.snp.trailing).offset(16)
            make.top.equalTo(chatLabel.snp.top).offset(-10)
            make.bottom.equalTo(chatLabel.snp.bottom).offset(10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(chatView.snp.leading).offset(-8)
            make.bottom.equalTo(chatView.snp.bottom)
        }
    }
}
