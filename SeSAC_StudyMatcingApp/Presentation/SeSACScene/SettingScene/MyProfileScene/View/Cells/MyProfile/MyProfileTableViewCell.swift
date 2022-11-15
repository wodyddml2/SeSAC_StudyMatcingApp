//
//  ProfileTableViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/14.
//

import UIKit

enum MyProfileText {
    static let gender = "내 성별"
    static let study = "자주 하는 스터디"
    static let permit = "내 번호 검색 허용"
    static let age = "상대방 연령대"
    static let withdraw = "회원탈퇴"
}

class MyProfileTableViewCell: BaseTableViewCell {
    
    let genderView: ProfileGenderView = {
        let view = ProfileGenderView()
        return view
    }()
    
    let studyView: ProfileStudyView = {
        let view = ProfileStudyView()
        return view
    }()
    
    let permitView: ProfilePermitView = {
        let view = ProfilePermitView()
        return view
    }()
    
    let ageView: ProfileAgeView = {
        let view = ProfileAgeView()
        return view
    }()
    
    let withdrawView: ProfileWithdrawView = {
        let view = ProfileWithdrawView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func configureUI() {
        [genderView, studyView, permitView, ageView, withdrawView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        genderView.snp.makeConstraints { make in
            make.top.equalTo(24)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(56)
        }
        
        studyView.snp.makeConstraints { make in
            make.top.equalTo(genderView.snp.bottom)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(75)
        }
        
        permitView.snp.makeConstraints { make in
            make.top.equalTo(studyView.snp.bottom)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(75)
        }
        
        ageView.snp.makeConstraints { make in
            make.top.equalTo(permitView.snp.bottom)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(90)
        }
        
        withdrawView.snp.makeConstraints { make in
            make.top.equalTo(ageView.snp.bottom)
            make.leading.trailing.bottom.equalTo(contentView)
        }
    }
}
