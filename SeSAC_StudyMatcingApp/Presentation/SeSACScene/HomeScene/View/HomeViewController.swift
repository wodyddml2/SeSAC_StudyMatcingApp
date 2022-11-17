//
//  HomeViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/11.
//

import UIKit
import MapKit
import CoreLocation

import RxSwift

final class HomeViewController: BaseViewController {
    
    private let locationManager = CLLocationManager()

    let mainView = HomeView()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserDeviceLocationSeviceAuthorization()

        locationManager.delegate = self

        bindViewModel()
    }
}

extension HomeViewController {
    private func checkUserDeviceLocationSeviceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        authorizationStatus = locationManager.authorizationStatus
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showSettingAlert(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
//        locationManager.stopUpdatingLocation()
        setRegionAnnotation(center: coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        view.makeToast("사용자의 위치를 가져오지 못했습니다.")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationSeviceAuthorization()
    }

}

extension HomeViewController {
    func setRegionAnnotation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        
        mainView.mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        
        annotation.coordinate = center
        annotation.title = "현재 위치"

        mainView.mapView.addAnnotation(annotation)
    }
}

extension HomeViewController {
    func bindViewModel() {
        mainView.matchingButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                let viewController = SearchViewController()
                
                vc.transition(viewController, transitionStyle: .push)
                
                if let coordinate = vc.locationManager.location?.coordinate {
                    viewController.viewModel.locationValue = coordinate
                }
                
            }
            .disposed(by: disposeBag)
    }
}
