//
//  HomeView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/12.
//

import UIKit

import MapKit

class HomeView: BaseView {
    lazy var mapView: MKMapView = {
        let view = MKMapView()
//        view.cameraZoomRange = .init(minCenterCoordinateDistance: 50, maxCenterCoordinateDistance: 3000)
        view.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.indentifier)
        return view
    }()
    
    let allButton: CommonButton = {
        let view = CommonButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        view.layer.cornerRadius = 0
        view.selectedStyle()
        view.setTitle("전체", for: .normal)
        return view
    }()
    
    let manButton: CommonButton = {
        let view = CommonButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        view.layer.cornerRadius = 0
        view.normalStyle(width: 0)
        view.setTitle("남자", for: .normal)
        return view
    }()
    
    let womanButton: CommonButton = {
        let view = CommonButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        view.layer.cornerRadius = 0
        view.normalStyle(width: 0)
        view.setTitle("여자", for: .normal)
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
    
    let pinImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "centerpin")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        self.addSubview(mapView)
        [stackView, currentLocationButton, matchingButton, pinImageView].forEach {
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
        
        pinImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.snp.centerY).offset(-35)
            make.height.width.equalTo(48)
        }
    }
}
