//
//  BirthView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import UIKit


class BirthView: LoginView {
    let yearView: BirthCustomView = {
        let view = BirthCustomView()
        
       
        return view
    }()
    
    let monthView: BirthCustomView = {
        let view = BirthCustomView()
        
       
        return view
    }()
    
    let dayView: BirthCustomView = {
        let view = BirthCustomView()
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
