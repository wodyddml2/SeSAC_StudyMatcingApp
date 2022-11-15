//
//  ProfileStudyView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/15.
//

import UIKit

class ProfileStudyView: BaseView {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = MyProfileText.study
        view.font = UIFont.notoSans(size: 14, family: .Regular)
        return view
    }()
    
    let studyTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "스터디를 입력해 주세요"
        return view
    }()
    
    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray3
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        [titleLabel, studyTextField, underlineView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(29)
            make.leading.equalToSuperview()
        }
        
        studyTextField.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview()
            make.leading.equalTo(underlineView.snp.leading).offset(12)
            make.height.equalTo(40)
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(studyTextField.snp.bottom)
            make.trailing.equalToSuperview()
            make.leading.equalTo(self.snp.centerX).offset(4)
            make.height.equalTo(1)
        }
    }
}
//usuallyStudyUnderlineView.snp.makeConstraints { make in
//                make.top.equalTo(usuallyStudyTextField.snp.bottom)
//                make.trailing.equalTo(contentView)
//                make.leading.equalTo(contentView.snp.centerX).offset(4)
//                make.height.equalTo(1)
//            }
//
//            usuallyStudyTextField.snp.makeConstraints { make in
//                make.centerY.trailing.equalTo(contentView)
//                make.leading.equalTo(usuallyStudyUnderlineView.snp.leading).offset(12)
//                make.height.equalTo(47)
//            }
