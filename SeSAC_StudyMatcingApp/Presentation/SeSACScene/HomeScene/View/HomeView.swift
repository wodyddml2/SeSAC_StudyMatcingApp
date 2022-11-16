//
//  HomeView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/12.
//

import UIKit

import MapKit

class HomeView: BaseView {
    let mapView: MKMapView = {
        let view = MKMapView()
      
        return view
    }()
    
    let allButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        let attributedTitle = NSAttributedString(string: "전체", attributes: [.font: UIFont.notoSans(size: 14, family: .Medium), .foregroundColor: UIColor.white])
        view.setAttributedTitle(attributedTitle, for: .normal)
        view.backgroundColor = .sesacGreen
        return view
    }()
    
    let manButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        let attributedTitle = NSAttributedString(string: "남자", attributes: [.font: UIFont.notoSans(size: 14, family: .Regular), .foregroundColor: UIColor.black])
        view.setAttributedTitle(attributedTitle, for: .normal)
        view.backgroundColor = .white
        return view
    }()
    
    let womanButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        let attributedTitle = NSAttributedString(string: "여자", attributes: [.font: UIFont.notoSans(size: 14, family: .Regular), .foregroundColor: UIColor.black])
        view.setAttributedTitle(attributedTitle, for: .normal)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [allButton, manButton, womanButton])
//        view.makeShadow(radius: 8, offset: CGSize(width: 10, height: 10), opacity: 1)
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let currentLocationButton: UIButton = {
        let view = UIButton()
        view.makeShadow(radius: 8, offset: CGSize(width: 0, height: 4), opacity: 0.2)
        view.makeCornerStyle(radius: 8)
        view.backgroundColor = .white
        view.setImage(UIImage(named: "location"), for: .normal)
        return view
    }()
    
    let matchingButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        view.makeShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor ,radius: 3, offset: CGSize(width: 0, height: 1), opacity: 1)
        view.makeCornerStyle(radius: view.frame.width / 2)
        view.backgroundColor = .focus
        view.setImage(UIImage(named: MatchImage.search), for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        self.addSubview(mapView)
        [stackView, currentLocationButton, matchingButton].forEach {
            mapView.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(52)
            make.width.equalTo(48)
            make.height.equalTo(144)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.width.height.equalTo(48)
        }
        
        matchingButton.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(100)
        }
        
    }
}
