//
//  ReviewStackView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/15.
//

import UIKit

class ReviewStackView: UIStackView {
    
//    let sesacTitleLabel: UILabel = {
//        let view = UILabel()
//        view.text = "새싹 타이틀"
//        view.font = UIFont.notoSans(size: 12, family: .Regular)
//        return view
//    }()
    
    let mannerButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("좋은 매너", for: .normal)
        return view
    }()
    
    let promiseButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("정확한 시간 약속", for: .normal)
        return view
    }()
    
    let fastButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("빠른 응답", for: .normal)
        return view
    }()
    
    let kindButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("친절한 성격", for: .normal)
        return view
    }()
    
    let skillButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("능숙한 실력", for: .normal)
        return view
    }()
    
    let beneficialButton: CommonButton = {
        let view = CommonButton()
        view.setTitle("유익한 시간", for: .normal)
        return view
    }()
    
    lazy var leftStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [mannerButton, fastButton, skillButton])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 8
        
        return view
    }()
    
    lazy var rightStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [promiseButton, kindButton, beneficialButton])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setConstraints()
        [leftStackView, rightStackView].forEach {
            self.addArrangedSubview($0)
        }
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 8
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        mannerButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(151)
        }
        
        promiseButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(151)
        }
        
        fastButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(151)
        }
        
        kindButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(151)
        }
        
        skillButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(151)
        }
        
        beneficialButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(151)
        }
    }
}
