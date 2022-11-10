//
//  BirthCustomView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import UIKit

class BirthCustomView: BaseView {
    
    let textField: UITextField = {
        let view = UITextField()
        view.placeholder = "1999"
        return view
    }()
    
    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.text = "년"
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 99, height: 48))
    }
    
    override func configureUI() {
        [textField, dateLabel, underlineView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self)
            make.width.equalTo(15)
            make.centerY.equalTo(self)
        }
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.bottom.equalTo(0)
            make.trailing.equalTo(dateLabel.snp.leading).offset(-4)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalTo(12)
            make.trailing.equalTo(dateLabel.snp.leading).offset(-4)
            make.centerY.equalTo(self)
            make.height.equalTo(self.snp.height).multipliedBy(0.9)
        }
    }
  
}
