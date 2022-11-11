//
//  NetworkMonitor.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/12.
//

import UIKit
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    
    func startMonitoring() {
        monitor.start(queue: queue)
        // pathUpdateHandler: 네트워크 경로를 수신하는 핸들러
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {return}
            
            self.isConnected = path.status == .satisfied
            
            if self.isConnected == false{
                DispatchQueue.main.async {
                    guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                    viewController.present(self.showNetworkAlert(), animated: true)
                }
            }
        }
    }
    
  
    func showNetworkAlert() -> UIAlertController {
        let alert = UIAlertController(title: "인터넷 연결이 원할하지 않습니다.", message: "wifi 또는 셀룰러를 활성화 해주세요.", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [ok, cancel].forEach {
            alert.addAction($0)
        }
       
        return alert
    }
    
}
