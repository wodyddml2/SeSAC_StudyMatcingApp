//
//  BirthView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import UIKit


class BirthView: LoginView {
    
    lazy var datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.locale = Locale(identifier: "ko-KR")
        view.preferredDatePickerStyle = .wheels
        return view
    }()
    
    lazy var yearView: BirthCustomView = {
        let view = BirthCustomView()
        view.textField.inputView = datePicker
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let monthView: BirthCustomView = {
        let view = BirthCustomView()
        view.textField.isEnabled = false
        return view
    }()
    
    let dayView: BirthCustomView = {
        let view = BirthCustomView()
        view.textField.isEnabled = false
        return view
    }()
  
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [yearView, monthView, dayView])
        view.axis = .horizontal
        view.spacing = 23
        view.alignment = .center
        view.distribution = .fillEqually
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        baseUI(labelText: "생년월일을 알려주세요", buttonText: "다음")
    }
    
    override func configureUI() {
        super.configureUI()
        [stackView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(authButton.snp.bottom).multipliedBy(0.75)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
