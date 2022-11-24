//
//  ChattingTableViewHeaderFooterView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/24.
//

import UIKit

class ChattingTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    let dateView: UIView = {
        let view = UIView()
        view.makeCornerStyle(radius: 20)
        view.backgroundColor = .gray7
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.notoSans(size: 12, family: .Medium)
        view.textColor = .white
        view.text = "SSSSSSSSSSSS"
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
        return view
    }()
    
    let infoLabel: UILabel = {
        let view = UILabel()
        view.text = "채팅을 통해 약속을 정해보세요 :)"
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        view.textColor = .gray6
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
    }
    
    private func setConstraints() {
        
    }
    
    
}
