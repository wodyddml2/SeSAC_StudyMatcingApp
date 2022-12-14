//
//  AppDelegate.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

import FirebaseCore
import FirebaseMessaging


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 
        NetworkMonitor.shared.startMonitoring()
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in
              
          }
        )
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print(error)
            } else if let token = token {
                UserManager.fcmToken = token
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        let dataDictonary: [String: String] = ["token": fcmToken ?? ""]
//        guard let fcmToken = fcmToken else { return }
//        UserManager.fcmToken =  fcmToken
//        //print(UserManager.fcmToken)
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDictonary)
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if userInfo[AnyHashable("matched")] as? String != "1" {
            completionHandler([.list, .banner, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        if userInfo[AnyHashable("matched")] as? String == "1" {
            let chat = ChattingViewController()
            chat.viewModel.uid = userInfo[AnyHashable("Uid")] as? String ?? ""
            chat.viewModel.nickname = userInfo[AnyHashable("Nick")] as? String ?? ""
            if vc is HomeViewController {
                vc.transition(chat, transitionStyle: .push)
            } else if vc is SettingViewController || vc is ShopViewController {
                if let home = vc.tabBarController?.viewControllers?[0] {
                    vc.tabBarController?.selectedViewController = home
                    home.topViewController?.transition(chat, transitionStyle: .push)
                }
            } else if vc is MyProfileViewController {
                vc.navigationController?.popViewController(animated: false, completion: {
                    guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                    
                    if let home = viewController.tabBarController?.viewControllers?[0] {
                        viewController.tabBarController?.selectedViewController = home
                        home.topViewController?.transition(chat, transitionStyle: .push)
                    }
                })
            }
        } else {
            if !(vc is HomeViewController) {
                if vc is SettingViewController || vc is ShopViewController {
                    if let home = vc.tabBarController?.viewControllers?[0] {
                        vc.tabBarController?.selectedViewController = home
                    }
                } else if vc is MyProfileViewController {
                    vc.navigationController?.popViewController(animated: false, completion: {
                        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                        if let home = viewController.tabBarController?.viewControllers?[0] {
                            viewController.tabBarController?.selectedViewController = home
                        }
                    })
                } else if vc is SearchViewController || vc is TabManSeSACViewController {
                    vc.navigationController?.popToRootViewController(animated: false)
                }
                
            }
            
            
        }
        
        //            if userInfo[AnyHashable("dodge")] as? String == "dodge" {
        //
        //           } else if userInfo[AnyHashable("studyAccepted")] as? String == "studyAccepted" {
        //
        //           }
    }
}
