//
//  ReviewStackView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/15.
//

import UIKit

class ReviewStackView: UIStackView {
    
    enum ReviewMent {
        static let manner = "좋은 매너"
        static let promise = "정확한 시간 약속"
        static let fast = "빠른 응답"
        static let kind = "친절한 성격"
        static let skill = "능숙한 실력"
        static let beneficial = "유익한 시간"
    }
    
    let mannerButton: CommonButton = {
        let view = CommonButton()
        view.setTitle(ReviewMent.manner, for: .normal)
        return view
    }()
    
    let promiseButton: CommonButton = {
        let view = CommonButton()
        view.setTitle(ReviewMent.promise, for: .normal)
        return view
    }()
    
    let fastButton: CommonButton = {
        let view = CommonButton()
        view.setTitle(ReviewMent.fast, for: .normal)
        return view
    }()
    
    let kindButton: CommonButton = {
        let view = CommonButton()
        view.setTitle(ReviewMent.kind, for: .normal)
        return view
    }()
    
    let skillButton: CommonButton = {
        let view = CommonButton()
        view.setTitle(ReviewMent.skill, for: .normal)
        return view
    }()
    
    let beneficialButton: CommonButton = {
        let view = CommonButton()
        view.setTitle(ReviewMent.beneficial, for: .normal)
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

}
