//
//  ChattingDateTableViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/24.
//

import UIKit

class ChattingDateTableViewCell: BaseTableViewCell {

    let dateView: UIView = {
        let view = UIView()
        view.makeCornerStyle(radius: 14)
        view.backgroundColor = .gray7
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.notoSans(size: 12, family: .Medium)
        view.textColor = .white
        view.text = "SSSSSSSSSSSS"
        view.textAlignment = .center
        return view
    }()
    
    let alarmImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bell")
        return view
    }()
    
    let alarmLabel: UILabel = {
        let view = UILabel()
        view.text = "땡땡땡님과 매칭되었습니다."
        view.font = UIFont.notoSans(size: 14, family: .Medium)
        view.textColor = .gray7
        view.textAlignment = .center
        return view
    }()
    
    let infoLabel: UILabel = {
        let view = UILabel()
        view.text = "채팅을 통해 약속을 정해보세요 :)"
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        view.textColor = .gray6
        view.textAlignment = .center
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureUI() {
        [dateView, dateLabel, alarmLabel, alarmImageView, infoLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        dateView.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.leading).offset(-16)
            make.trailing.equalTo(dateLabel.snp.trailing).offset(16)
            make.top.equalTo(dateLabel.snp.top).offset(-4)
            make.bottom.equalTo(dateLabel.snp.bottom).offset(6)
        }
        
        alarmLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(12)
            make.top.equalTo(dateView.snp.bottom).offset(12)
        }
        
        alarmImageView.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.trailing.equalTo(alarmLabel.snp.leading).offset(-4)
            make.centerY.equalTo(alarmLabel.snp.centerY)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(alarmLabel.snp.bottom).offset(2)
        }
    }

}
