//
//  ProfileTableViewCell.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/14.
//

import UIKit

import MultiSlider

enum MyProfileIndex: Int {
    case gender, study, permit, age, withdraw
}

enum MyProfileText {
    static let gender = "내 성별"
    static let study = "자주 하는 스터디"
    static let permit = "내 번호 검색 허용"
    static let age = "상대방 연령대"
    static let withdraw = "회원탈퇴"
}

class MyProfileTableViewCell: BaseTableViewCell {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        
        return view
    }()
    
    let manButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("남자", for: .normal)
        return view
    }()
    
    let womanButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("여자", for: .normal)
        return view
    }()

    let usuallyStudyTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "스터디를 입력해 주세요"
        return view
    }()
    
    let usuallyStudyUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray3
        return view
    }()
    
    let phonePermitSwitch: UISwitch = {
        let view = UISwitch()
        
        return view
    }()
    
    let ageLabel: UILabel = {
        let view = UILabel()
        view.text = "18 - 35"
        view.textColor = .sesacGreen
        return view
    }()
    
    let ageSlider: MultiSlider = {
        let view = MultiSlider()
        view.orientation = .horizontal
        view.thumbCount = 2
        view.minimumValue = 18
        view.maximumValue = 65
        view.tintColor = .sesacGreen
        view.thumbImage = UIImage(named: "slider")!
        return view
    }()
    
    let withdrawButton: UIButton = {
        let view = UIButton()
        
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func configureUI() {
        [titleLabel, manButton, womanButton, usuallyStudyTextField, usuallyStudyUnderlineView, phonePermitSwitch, ageLabel, ageSlider, withdrawButton].forEach {
            contentView.addSubview($0)
        }
        
    }
    
    func setConstraint(index: Int) {
        switch MyProfileIndex(rawValue: index) {
        case .gender:
            phonePermitSwitch.isHidden = true
            ageSlider.isHidden = true
            defaultConstraints()
            womanButton.snp.makeConstraints { make in
                make.centerY.trailing.equalTo(self)
                make.width.equalTo(56)
                make.height.equalTo(48)
            }
            
            manButton.snp.makeConstraints { make in
                make.centerY.equalTo(self)
                make.width.equalTo(womanButton.snp.width)
                make.height.equalTo(womanButton.snp.height)
                make.trailing.equalTo(womanButton.snp.leading).offset(-8)
            }
        case .study:
            phonePermitSwitch.isHidden = true
            ageSlider.isHidden = true
            defaultConstraints()
            usuallyStudyUnderlineView.snp.makeConstraints { make in
                make.top.equalTo(usuallyStudyTextField.snp.bottom)
                make.trailing.equalTo(self)
                make.leading.equalTo(self.snp.centerX).offset(4)
                make.height.equalTo(1)
            }
            
            usuallyStudyTextField.snp.makeConstraints { make in
                make.centerY.trailing.equalTo(self)
                make.leading.equalTo(usuallyStudyUnderlineView.snp.leading).offset(12)
                make.height.equalTo(47)
            }
        case .permit:
            ageSlider.isHidden = true
            defaultConstraints()
            phonePermitSwitch.snp.makeConstraints { make in
                make.centerY.equalTo(self)
                make.trailing.equalTo(self).offset(-2)
            }
        case .age:
            phonePermitSwitch.isHidden = true
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(13)
                make.leading.equalTo(self)
            }
            ageLabel.snp.makeConstraints { make in
                make.trailing.equalTo(self)
                make.centerY.equalTo(titleLabel.snp.centerY)
            }
            
            ageSlider.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom)
                make.trailing.equalToSuperview().offset(-12)
                make.leading.equalToSuperview()
            }
            
        case .withdraw:
            ageSlider.isHidden = true
            phonePermitSwitch.isHidden = true
            defaultConstraints()
            withdrawButton.snp.makeConstraints { make in
                make.edges.equalTo(titleLabel)
            }
        default:
            break
        }
    }

    func defaultConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.leading.equalTo(self)
        }
    }
}
