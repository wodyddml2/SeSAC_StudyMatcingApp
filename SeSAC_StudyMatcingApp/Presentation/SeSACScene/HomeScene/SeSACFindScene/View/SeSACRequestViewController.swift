//
//  SeSACFindViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/19.
//

import UIKit

import RxSwift
import RxDataSources

enum SeSACFindRow: Int {
    case image, review
}

class SeSACRequestViewController: BaseViewController {
    
    let mainView = SeSACFindView()
    
    let viewModel = SeSACRequestViewModel()
    let disposeBag = DisposeBag()
    
    var dataSources: RxTableViewSectionedReloadDataSource<SeSACFindSectionModel>?

    var heightChange: [Bool] = []

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.searchSesac.accept(true)
    }

    func setTableView(sesacInfo: SeSACSearchDTO) {
        dataSources = RxTableViewSectionedReloadDataSource<SeSACFindSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            switch SeSACFindRow(rawValue: indexPath.row) {
            case .image:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SeSACFindImageTableViewCell.reusableIdentifier, for: indexPath) as? SeSACFindImageTableViewCell else {return UITableViewCell()}
                cell.sesacBackgroundImageView.image = UIImage.sesacBackgroundImage(num: item.backgroundImage)
                cell.sesacImageView.image = UIImage.sesacImage(num: item.image)
                return cell
            case .review:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SeSACFindReviewTableViewCell.reusableIdentifier, for: indexPath) as? SeSACFindReviewTableViewCell else {return UITableViewCell()}
                cell.tag = indexPath.section
                cell.sesacReviewImageView.image = self.heightChange[indexPath.section] ? UIImage(systemName: "chevron.up")! : UIImage(systemName: "chevron.down")!
                cell.setFindData(item: item)
                return cell
            default: return UITableViewCell()
            }
        })
        var sections: [SeSACFindSectionModel] = []
        
        for i in sesacInfo.fromQueueDB {
            sections.append(SeSACFindSectionModel(items: [SeSACFind(backgroundImage: i.background, image: i.sesac), SeSACFind(nickname: i.nick, sesacTitle: i.reputation, comment: i.reviews)]))
        }
        
        let data = Observable<[SeSACFindSectionModel]>.just(sections)
        
        data
            .bind(to: mainView.tableView.rx.items(dataSource: dataSources!))
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe { vc, index in
                guard let cell =  vc.mainView.tableView.cellForRow(at: index) as? SeSACFindReviewTableViewCell else {return}
               
                if index.section == cell.tag {
                    if index.row == 1 {
                        vc.heightChange[cell.tag].toggle()
                        vc.mainView.tableView.reloadRows(at: [IndexPath(row: index.row, section: index.section)], with: .fade)
                    }
                }
                
            }
            .disposed(by: disposeBag)
         
        sections.isEmpty ? noSeSACHidden(bool: false) :  noSeSACHidden(bool: true)
        noSeSAC()
        
        heightChange = Array(repeating: false, count: sections.count)
    }
    
    func noSeSACHidden(bool: Bool) {
        mainView.sesacImageView.isHidden = bool
        mainView.titleLabel.isHidden = bool
        mainView.subTitleLabel.isHidden = bool
        mainView.changeButton.isHidden = bool
        mainView.reloadButton.isHidden = bool
    }
    
    func noSeSAC() {
        mainView.titleLabel.text = "아쉽게도 주변에 새싹이 없어요ㅠ"
        mainView.subTitleLabel.text = "스터디를 변경하거나 조금만 더 기다려 주세요!"
        mainView.changeButton.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.requestDelete(SearchViewController())
            }
            .disposed(by: disposeBag)
    }
    
}

extension SeSACRequestViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch SeSACFindRow(rawValue: indexPath.row) {
        case .image:
            return 225
        case .review:
            return heightChange[indexPath.section] ? UITableView.automaticDimension : 58
        default:
            return 0
        }
    }
}

extension SeSACRequestViewController {
    private func bindViewModel() {
        let input = SeSACRequestViewModel.Input(viewDidLoadEvent: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        output.sesacInfo
            .withUnretained(self)
            .subscribe (onNext: { vc, sesacInfo in
                print(sesacInfo)
                vc.setTableView(sesacInfo: sesacInfo)
            })
            .disposed(by: disposeBag)
        
        mainView.reloadButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.tableView.dataSource = nil
                vc.mainView.tableView.delegate = nil
                vc.viewModel.requsetSearch(output: output)
            }
            .disposed(by: disposeBag)
        
        output.searchSesac
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] bool in
                guard let self = self else {return}
                if bool {
                    self.mainView.tableView.dataSource = nil
                    self.mainView.tableView.delegate = nil
                    self.viewModel.requsetSearch(output: output)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    func requestDelete<T: UIViewController>(_ vc: T) {
        viewModel.requestFindDelete {  [weak self] value in
            guard let self = self else {return}
            switch StatusCode(rawValue: value) {
            case .success:
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]

                for viewController in viewControllers {
                    if let rootVC = viewController as? T {
                        self.navigationController?.popToViewController(rootVC, animated: true)
                    }
                }
            case .declarationOrMatch:
                print("매칭 상태임")
            case .firebaseError:
                self.renewalDelete(T())
            default:
                self.mainView.makeToast("에러가 발생했습니다.", position: .center)
            }
        }
    }
    
    func renewalDelete<T: UIViewController>(_ vc: T) {
        viewModel.renewalFindDeleteRequest { [weak self] in
            guard let self = self else {return}
            self.requestDelete(T())
        }
    }
}
