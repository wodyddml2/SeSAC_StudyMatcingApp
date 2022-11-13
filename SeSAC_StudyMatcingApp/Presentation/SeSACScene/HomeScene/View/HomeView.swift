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
        view.axis = .vertical
//        view.spacing = 0
        view.alignment = .fill
        view.distribution = .fill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        self.addSubview(mapView)
        [stackView].forEach {
            mapView.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
        }
    }
}
