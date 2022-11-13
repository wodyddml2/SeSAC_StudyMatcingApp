//
//  GenderView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import UIKit

class GenderView: LoginView {
    
    let genderIntroLabel: UILabel = {
        let view = UILabel()
        view.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        view.textColor = .gray7
        view.textAlignment = .center
        view.font = UIFont.notoSans(size: 16, family: .Regular)
        return view
    }()
    
    let manView: GenderButtonView = {
        let view = GenderButtonView()
        view.genderImage.image = UIImage.commonImage(name: Gender.manImage)
        view.genderLabel.text = "남자"
        return view
    }()
    
    let womanView: GenderButtonView = {
        let view = GenderButtonView()
        view.genderImage.image = UIImage.commonImage(name: Gender.womanImage)
        view.genderLabel.text = "여자"
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseUI(labelText: "성별을 선택해 주세요", buttonText: "다음")
    }
    
    override func configureUI() {
        super.configureUI()
        [genderIntroLabel, manView, womanView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        genderIntroLabel.snp.makeConstraints { make in
            make.top.equalTo(introLabel.snp.bottom).offset(8)
            make.centerX.equalTo(self)
        }
        
        manView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(genderIntroLabel.snp.bottom).offset(32)
            make.bottom.equalTo(authButton.snp.top).offset(-32)
            make.trailing.equalTo(self.snp.centerX).offset(-6)
        }

        womanView.snp.makeConstraints { make in
            make.trailing.equalTo(-16)
            make.top.equalTo(genderIntroLabel.snp.bottom).offset(32)
            make.bottom.equalTo(authButton.snp.top).offset(-32)
            make.leading.equalTo(self.snp.centerX).offset(6)
        }
    }
}
