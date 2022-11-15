//
//  ProfileViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/14.
//

import UIKit

import RxDataSources
import RxSwift
import RxCocoa

enum ProfileSection: Int {
    case image, review, info
}

final class MyProfileViewController: BaseViewController {

    let tableView: UITableView = {
        let view = UITableView()
        view.register(MyProfileTableViewCell.self, forCellReuseIdentifier: MyProfileTableViewCell.reusableIdentifier)
        view.register(MyProfileReviewTableViewCell.self, forCellReuseIdentifier: MyProfileReviewTableViewCell.reusableIdentifier)
        view.register(MyProfileImageTableViewCell.self, forCellReuseIdentifier: MyProfileImageTableViewCell.reusableIdentifier)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    let viewModel = MyProfileViewModel()
    
    var dataSource: RxTableViewSectionedReloadDataSource<MyProfileSectionModel>?
    
    var autoBool: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func configureUI() {
        navigationBarCommon(title: "내정보")
        view.addSubview(tableView)
        setTableView()
        bindViewModel()
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func setTableView() {
        dataSource = RxTableViewSectionedReloadDataSource<MyProfileSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            switch ProfileSection(rawValue: indexPath.section) {
            case .image:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProfileImageTableViewCell.reusableIdentifier, for: indexPath) as? MyProfileImageTableViewCell else { return UITableViewCell() }
                
                return cell
            case .review:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProfileReviewTableViewCell.reusableIdentifier, for: indexPath) as? MyProfileReviewTableViewCell else { return UITableViewCell() }
                
                return cell
            case .info:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProfileTableViewCell.reusableIdentifier, for: indexPath) as? MyProfileTableViewCell else { return UITableViewCell() }
                
                return cell
                
            default:
                return UITableViewCell()
            }
        })
        let sections = [
            MyProfileSectionModel(items: [MyProfileModel()]),
            MyProfileSectionModel(items: [MyProfileModel()]),
            MyProfileSectionModel(items: [MyProfileModel()])
        ]
    
        let data = Observable<[MyProfileSectionModel]>.just(sections)
        
        data
            .bind(to: tableView.rx.items(dataSource: dataSource!))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe { vc, index in
                if index.section == 1 {
                    vc.autoBool.toggle()
                    vc.tableView.reloadRows(at: [IndexPath(row: index.row, section: index.section)], with: .fade)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension MyProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch ProfileSection(rawValue: indexPath.section) {
        case .image:
            return 225
        case .review:
            return autoBool ? UITableView.automaticDimension : 58
        case .info:
            return 415
        default:
            return 0
        }
    }
}

extension MyProfileViewController {
    private func bindViewModel() {
        let input = MyProfileViewModel.Input(viewDidLoadEvent: Observable.just(()))
        let output = viewModel.transform(input: input)
      
        output.networkFailed.asDriver(onErrorJustReturn: false)
            .drive (onNext: { error in
                    if error == true {
                        self.view.makeToast("사용자의 정보를 불러오는데 실패했습니다.")
                    }
                
            }).disposed(by: disposeBag)
        
        output.sesacInfo.subscribe { sesac in
            print(sesac)
        }
        .disposed(by: disposeBag)
    }
}
