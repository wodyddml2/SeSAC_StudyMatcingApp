//
//  SeSACAcceptViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/21.
//

import UIKit

import RxSwift
import RxDataSources

final class SeSACAcceptViewController: BaseViewController {
    
    let mainView = SeSACFindView()
    
    let viewModel = SeSACRequestViewModel()
    let disposeBag = DisposeBag()
    
    private var dataSources: RxTableViewSectionedReloadDataSource<SeSACFindSectionModel>?

    private var heightChange: [Bool] = []
    private var info: [FromQueueDB] = []

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

    private func setTableView(sesacInfo: SeSACSearchDTO) {
        dataSources = RxTableViewSectionedReloadDataSource<SeSACFindSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            switch SeSACFindRow(rawValue: indexPath.row) {
            case .image:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SeSACFindImageTableViewCell.reusableIdentifier, for: indexPath) as? SeSACFindImageTableViewCell else {return UITableViewCell()}
                cell.multiButton.setTitle("수락하기", for: .normal)
                cell.multiButton.blueButton()
                cell.sesacBackgroundImageView.image = UIImage.sesacBackgroundImage(num: item.backgroundImage)
                cell.sesacImageView.image = UIImage.sesacImage(num: item.image)
                
                cell.multiButton.tag = indexPath.section
                cell.multiButton.addTarget(self, action: #selector(self.requestButtonTapped), for: .touchUpInside)
                return cell
            case .review:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SeSACFindReviewTableViewCell.reusableIdentifier, for: indexPath) as? SeSACFindReviewTableViewCell else {return UITableViewCell()}
                cell.tag = indexPath.section
                cell.sesacReviewImageView.image = self.heightChange[indexPath.section] ? UIImage(systemName: "chevron.up")! : UIImage(systemName: "chevron.down")!
                cell.setFindData(item: item)
                
                cell.reviewView.sesacReviewButton.tag = indexPath.section
                
                cell.reviewView.sesacReviewButton.addTarget(self, action: #selector(self.reviewButtonTapped), for: .touchUpInside)
                
                cell.reviewView.sesacStudyLabel.text = cell.wishStudyLabel(item: item)
                return cell
            default: return UITableViewCell()
            }
        })
        var sections: [SeSACFindSectionModel] = []
        
        for i in sesacInfo.fromQueueDBRequested {
            sections.append(SeSACFindSectionModel(items: [SeSACFind(uid: i.uid, backgroundImage: i.background, image: i.sesac), SeSACFind(nickname: i.nick, sesacTitle: i.reputation, comment: i.reviews, studyList: i.studylist)]))
        }
        
        let data = Observable<[SeSACFindSectionModel]>.just(sections)
        
        data
            .bind(to: mainView.tableView.rx.items(dataSource: dataSources!))
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
         
        sections.isEmpty ? noSeSACHidden(bool: false) :  noSeSACHidden(bool: true)
        
        heightChange = Array(repeating: false, count: sections.count)
    }
    
    @objc func reviewButtonTapped(_ sender: UIButton) {
        let vc = ReviewTableViewController()
        vc.reviewList = info[sender.tag].reviews
       
        transition(vc, transitionStyle: .push)
    }
    
    @objc func requestButtonTapped(_ sender: UIButton) {
        let vc = PopupViewController()
        vc.uid = info[sender.tag].uid
        vc.request = false
        transition(vc, transitionStyle: .presentOverFull)
    }
    
    private func noSeSACHidden(bool: Bool) {
        mainView.sesacImageView.isHidden = bool
        mainView.titleLabel.isHidden = bool
        mainView.subTitleLabel.isHidden = bool
        mainView.changeButton.isHidden = bool
        mainView.reloadButton.isHidden = bool
        mainView.titleLabel.text = "아직 받은 요청이 없어요ㅠ"
    }

}

extension SeSACAcceptViewController: UITableViewDelegate {

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

extension SeSACAcceptViewController {
    private func bindViewModel() {
        let input = SeSACRequestViewModel.Input(
            reload: mainView.reloadButton.rx.tap,
            change: mainView.changeButton.rx.tap,
            refresh:  mainView.refreshControl.rx.controlEvent(.valueChanged),
            tableItem: mainView.tableView.rx.itemSelected
        )
        
        let output = viewModel.transform(input: input)
        
        output.sesacInfo
            .withUnretained(self)
            .subscribe (onNext: { vc, sesacInfo in
                vc.info = sesacInfo.fromQueueDBRequested
                vc.setTableView(sesacInfo: sesacInfo)
            })
            .disposed(by: disposeBag)
        
        output.networkFailed
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] error in
                guard let self = self else {return}
                if error == true {
                    self.view.makeToast("사용자의 정보를 불러오는데 실패했습니다.")
                }
            }).disposed(by: disposeBag)

        output.tableItem
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
        
        bindEmptyScreen(output: output)
        bindSearchRequest(output: output)
    }
    
    private func bindSearchRequest(output: SeSACRequestViewModel.Output) {
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
        
        output.refresh
            .withUnretained(self)
            .bind {vc, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    vc.mainView.tableView.dataSource = nil
                    vc.mainView.tableView.delegate = nil
                    vc.viewModel.requsetSearch(output: output)
                    vc.mainView.refreshControl.endRefreshing()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindEmptyScreen(output: SeSACRequestViewModel.Output) {
        output.reload
            .throttle(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.tableView.dataSource = nil
                vc.mainView.tableView.delegate = nil
                vc.viewModel.requsetSearch(output: output)
            }
            .disposed(by: disposeBag)
        
        output.change
            .throttle(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.requestDelete(SearchViewController())
            }
            .disposed(by: disposeBag)
    }
}

extension SeSACAcceptViewController {
    private func requestDelete<T: UIViewController>(_ vc: T) {
        viewModel.requestFindDelete {  [weak self] value in
            guard let self = self else {return}
            switch StatusCode(rawValue: value) {
            case .success:
                self.navigationPopToViewController(T())
            case .declarationOrMatch:
                print("매칭 상태임")
            case .firebaseError:
                self.renewalDelete(T())
            default:
                self.mainView.makeToast("에러가 발생했습니다.", position: .center)
            }
        }
    }
    
    private func renewalDelete<T: UIViewController>(_ vc: T) {
        viewModel.renewalFindDeleteRequest { [weak self] in
            guard let self = self else {return}
            self.requestDelete(T())
        }
    }
}
