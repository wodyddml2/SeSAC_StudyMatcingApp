//
//  TabManViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/21.
//

import UIKit

import Tabman
import Pageboy

class TabManSeSACViewController: TabmanViewController {
    
    private let tabView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var viewControllers: [UIViewController] = []
    
    let firstVC = SeSACRequestViewController()
    let secondVC = SeSACAcceptViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setTabMan()
    }

    private func setTabMan() {
      
        viewControllers.append(contentsOf: [firstVC, secondVC])
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        
        bar.backgroundView.style = .blur(style: .light)
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bar.layout.contentMode = .fit
        
        bar.buttons.customize { button in
            button.tintColor = .gray6
            button.selectedTintColor = .sesacGreen
            button.font = UIFont.notoSans(size: 14, family: .Medium)
            button.selectedFont = UIFont.notoSans(size: 14, family: .Medium)
        }
        
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = .sesacGreen
        
        addBar(bar, dataSource: self, at: .custom(view: tabView, layout: nil))
    }
    
    func configureUI() {
        view.addSubview(tabView)
        
        tabView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
    }
    
}

extension TabManSeSACViewController: PageboyViewControllerDataSource, TMBarDataSource {
    public func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "주변 새싹")
        case 1:
            return TMBarItem(title: "받은 요청")
        default:
            return TMBarItem(title: "")
        }
    }
    
    public func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    public func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    public func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
    
}
