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
        mainView.mapView.delegate = self
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
            setRegionAnnotation(center: CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734))
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
        locationManager.stopUpdatingLocation()
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

        mainView.mapView.addAnnotation(annotation)
        
        
    }
}

extension HomeViewController {
    
    func bindViewModel() {
        let coordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734) //
        let input = HomeViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            lat: 37.517819364682694,
            long: 126.88647317074734,
            match: mainView.matchingButton.rx.tap,
            currentLocation: mainView.currentLocationButton.rx.tap)
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
    
       
        output.mapCameraMove
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] move in
                guard let self = self else {return}
                if move == true {
                    let location = self.mainView.mapView.centerCoordinate
//                    self.viewModel.requestSearchSeSAC(output: output, lat: location.latitude, long: location.longitude)
                }
            }).disposed(by: disposeBag)
        
        buttonTap(output: output)
    }
    
    private func buttonTap(output: HomeViewModel.Output) {
        output.currentLocation
            .withUnretained(self)
            .bind { vc, _ in
                vc.checkUserDeviceLocationSeviceAuthorization()
            }
            .disposed(by: disposeBag)
        
        output.match
            .withUnretained(self)
            .bind { vc, _ in
                let viewController = SearchViewController()
                vc.transition(viewController, transitionStyle: .push)
                let coordinate = vc.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
                viewController.viewModel.locationValue = coordinate
                
            }
            .disposed(by: disposeBag)
        
        
    }
    
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        viewModel.mapCameraMove.accept(false)
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.viewModel.mapCameraMove.accept(true)
            mapView.isScrollEnabled = true
            mapView.isZoomEnabled = true
        }
    }
}
