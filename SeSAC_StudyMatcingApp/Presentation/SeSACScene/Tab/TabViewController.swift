//
//  TabViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/12.
//

import UIKit

final class TabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        setupTabBarAppearence()
    }
   
    
    private func setupTabBar(viewController: UIViewController, title: String, image: String) -> UINavigationController {
        
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = UIImage(named: image)
     
        let navigationViewController = UINavigationController(rootViewController: viewController)
        return navigationViewController
    }
    
    private func configureTabBar() {
        let homeVC = setupTabBar(viewController: HomeViewController(), title: "홈", image: TabImage.home)

        let shopVC = setupTabBar(viewController: ShopViewController(), title: "새싹샵", image: TabImage.shop)
      
        let chattingVC = setupTabBar(viewController: ChattingViewController(), title: "새싹친구", image: TabImage.chat)
        
        let profileVC = setupTabBar(viewController: SettingViewController(), title: "내정보", image: TabImage.profile)

        setViewControllers([homeVC, shopVC, chattingVC, profileVC], animated: true)
    }
    
    private func setupTabBarAppearence() {
        let tabBarAppearance = UITabBarItemAppearance()
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        tabBarAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.sesacGreen, NSAttributedString.Key.font: UIFont.notoSans(size: 12, family: .Regular)]
        appearance.stackedLayoutAppearance = tabBarAppearance
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
   
        tabBar.backgroundColor = .white
        tabBar.tintColor = .sesacGreen
    }
    
    
    
}

