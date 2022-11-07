//
//  ViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    private var pageViewControllerList: [UIViewController] = []
    
    private let pageContorl: UIPageControl = {
        let view = UIPageControl()
        view.pageIndicatorTintColor = .lightGray
        view.currentPageIndicatorTintColor = .black
        return view
    }()
    
    private let startButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.sesacGreen
        view.setTitle("시작하기", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    override func configureUI() {
        [pageViewController.view, pageContorl, startButton].forEach {
            view.addSubview($0)
        }
        
        createPageViewController()
        configurePageViewController()
        
        pageContorl.numberOfPages = pageViewControllerList.count
        
        bindTo()
    }
    override func setConstraints() {
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view)
            
        }
        pageContorl.snp.makeConstraints { make in
            make.bottom.equalTo(startButton.snp.top).offset(-42)
            make.centerX.equalTo(view)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(-50)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(48)
        }
   
    }

}

extension OnboardingViewController {
    private func createPageViewController() {
        let firstVC = FirstViewController()
        let secondVC = SecondViewController()
        let thirdVC = ThirdViewController()
        pageViewControllerList = [firstVC, secondVC, thirdVC]
    }
    
    private func configurePageViewController() {
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        
        guard let firstView = pageViewControllerList.first else { return }
        
        pageViewController.setViewControllers([firstView], direction: .forward, animated: true)
    }
}

extension OnboardingViewController {
    private func bindTo() {
        startButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.sceneChange(viewController: NumberViewController())
                UserManager.onboarding = true
            }
            .disposed(by: disposeBag)
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        return previousIndex < 0 ? nil : pageViewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        return nextIndex >= pageViewControllerList.count ? nil : pageViewControllerList[nextIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let firstView = pageViewController.viewControllers?.first, let index = pageViewControllerList.firstIndex(of: firstView) else { return }
        
        pageContorl.currentPage = index
        
    }
    
}
