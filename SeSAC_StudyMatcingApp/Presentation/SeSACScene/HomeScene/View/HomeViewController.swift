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
    let viewModel = HomeViewModel()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
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
        guard let coordinate = locationManager.location?.coordinate else {return}
        let input = HomeViewModel.Input(viewDidLoadEvent: Observable.just(()), lat: 37.517819364682694, long: 126.88647317074734)
        let output = viewModel.transform(input: input)
        
        // 낼 다시
        output.searchInfo
            .subscribe { s in
                print(s)
            }
            .disposed(by: disposeBag)
        
        output.matchInfo
            .subscribe { s in
                print(s)
            }
            .disposed(by: disposeBag)
        
        output.networkFailed
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] error in
                guard let self = self else {return}
                if error == true {
                    self.view.makeToast("사용자의 정보를 불러오는데 실패했습니다.")
                }
            }).disposed(by: disposeBag)
        
        output.normalStatus
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] normal in
                guard let self = self else {return}
                if normal == true {
                    self.view.makeToast("normal")
                }
            }).disposed(by: disposeBag)
    
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
