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
    var sesacUsers: [SeSACUser] = []
    
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
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734), latitudinalMeters: 700, longitudinalMeters: 700)
        
        mainView.mapView.setRegion(region, animated: true)

        var annotation: [CustomAnnotation] = []
        
        for user in sesacUsers {
            let point = CustomAnnotation(image: user.sesac, coordinate: CLLocationCoordinate2D(latitude: user.lat, longitude: user.long))
            annotation.append(point)
        }
        
        mainView.mapView.addAnnotations(annotation)
    }
}

extension HomeViewController {
    
    func bindViewModel() {
        let input = HomeViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            match: mainView.matchingButton.rx.tap,
            currentLocation: mainView.currentLocationButton.rx.tap)
        let output = viewModel.transform(input: input)

        output.searchInfo
            .withUnretained(self)
            .subscribe (onNext: { vc, result in
                print(result)
                result.fromQueueDB.forEach {vc.sesacUsers.append(SeSACUser(lat: $0.lat, long: $0.long, sesac: $0.sesac, gender: $0.gender))}
                result.fromQueueDBRequested.forEach {vc.sesacUsers.append(SeSACUser(lat: $0.lat, long: $0.long, sesac: $0.sesac, gender: $0.gender))}
                let location = self.mainView.mapView.centerCoordinate
                self.setRegionAnnotation(center: location)
            })
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
                    print("Ssssssssss")
                    self.mainView.matchingButton.setImage(UIImage(named: MatchImage.message), for: .normal)
                }
            }).disposed(by: disposeBag)
    
       
        output.mapCameraMove
            .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] move in
                guard let self = self else {return}
                if move == true {
                    let location = self.mainView.mapView.centerCoordinate
                    self.viewModel.requestSearchSeSAC(output: output, lat: location.latitude, long: location.longitude)
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
                let location = self.mainView.mapView.centerCoordinate
                viewController.viewModel.locationValue = location
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else {return nil}
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.indentifier) as? CustomAnnotationView else {return nil}
        
        annotationView.annotation = annotation
        let size = CGSize(width: 95, height: 95)
        
        UIGraphicsBeginImageContext(size)
        
        let image = UIImage.sesacImage(num: annotation.image ?? 0)
        
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // draw: 이 메서드를 직접 호출하면 안 된다고 한다. - 강한 참조 때문? 나중에 한 번 더 찾아보자
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView.image = resizedImage
        
        UIGraphicsEndImageContext()
        
        return annotationView
    }
}

