//
//  TabManViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/21.
//

import UIKit

import FirebaseAuth
import Tabman
import Pageboy
import RxSwift

enum SeSACFindRow: Int {
    case image, review
}

class TabManSeSACViewController: TabmanViewController {
    
    private let tabView: UIView = {
        let view = UIView()
        return view
    }()

    private var viewControllers: [UIViewController] = []
    
    let firstVC = SeSACRequestViewController()
    let secondVC = SeSACAcceptViewController()
    
    let viewModel = SeSACRequestViewModel()
    
    let disposeBag = DisposeBag()
    var timerDisposable: Disposable?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        setTabMan()
        
        navigationBarStyle()
        
        bindViewModel()
    }
    
    private func navigationBarStyle() {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        
        navigationItem.title = "새싹 찾기"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
    
        let navigationAppearance = UINavigationBarAppearance()
        navigationController?.navigationBar.scrollEdgeAppearance = navigationAppearance
        navigationController?.navigationBar.standardAppearance = navigationAppearance
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(backbuttonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(cancelButtonTapped))
    }
    
    @objc func backbuttonTapped() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]

        for viewController in viewControllers {
            if let rootVC = viewController as? HomeViewController {
                navigationController?.popToViewController(rootVC, animated: true)
            }
        }
    }
    
    @objc func cancelButtonTapped() {
        requestDelete()
    }

    func requestDelete() {
        viewModel.requestFindDelete {  [weak self] value in
            guard let self = self else {return}
            switch StatusCode(rawValue: value) {
            case .success:
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]

                for viewController in viewControllers {
                    if let rootVC = viewController as? HomeViewController {
                        self.navigationController?.popToViewController(rootVC, animated: true)
                    }
                }
            case .declarationOrMatch:
                print("매칭 상태임")
            case .firebaseError:
                self.renewalDelete()
            default:
                self.view.makeToast("에러가 발생했습니다.", position: .center)
            }
        }
    }
    
    func renewalDelete() {
        viewModel.renewalFindDeleteRequest { [weak self] in
            guard let self = self else {return}
            self.requestDelete()
        }
    }
    
    func bindViewModel() {
        viewModel.match
            .bind (onNext: { result in
                if result.matched == 1 {
                    print("매칭됨")
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.matchError
            .withUnretained(self)
            .bind { vc, bool in
                if bool {
                    vc.view.makeToast("에러가 발생했습니다.", position: .center)
                }
            }
            .disposed(by: disposeBag)
        
        timerDisposable = Observable<Int>.timer(.milliseconds(0), period: .seconds(5), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.viewModel.requestMYQueue()
            })
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
