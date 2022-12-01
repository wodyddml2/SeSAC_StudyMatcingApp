//
//  TabmanShopViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/12/01.
//
import UIKit

import FirebaseAuth
import Tabman
import Pageboy
import RxSwift

final class TabmanShopViewController: TabmanViewController {

    private var viewControllers: [UIViewController] = []
    
    let firstVC = SeSACShopViewController()
    let secondVC = BgShopViewController()
 
    let disposeBag = DisposeBag()
      
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setTabMan()

    }
    private func setTabMan() {
      
        viewControllers.append(contentsOf: [firstVC, secondVC])
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        
        bar.backgroundView.style = .blur(style: .light)
        bar.layout.contentInset = UIEdgeInsets.zero
        bar.layout.contentMode = .fit
        
        bar.buttons.customize { button in
            button.tintColor = .gray6
            button.selectedTintColor = .sesacGreen
            button.font = UIFont.notoSans(size: 14, family: .Medium)
            button.selectedFont = UIFont.notoSans(size: 14, family: .Medium)
        }
        
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = .sesacGreen
        
        addBar(bar, dataSource: self, at: .top)
    }
    

    
}

extension TabmanShopViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "새싹")
        case 1:
            return TMBarItem(title: "배경")
        default:
            return TMBarItem(title: "")
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
}

