//
//  ShopView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/30.
//

import UIKit

class ShopView: BaseView {
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .red
        return view
    }()
    
    let sesacImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .blue
        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        [backgroundImageView, sesacImageView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(172)
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.top).offset(10)
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(-5)
            make.width.equalTo(sesacImageView.snp.height)
        }
        

    }
}

