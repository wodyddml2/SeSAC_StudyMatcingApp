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

class MyProfileViewController: BaseViewController {

    let tableView: UITableView = {
        let view = UITableView()
        view.register(MyProfileTableViewCell.self, forCellReuseIdentifier: MyProfileTableViewCell.reusableIdentifier)
        view.register(MyProfileReviewTableViewCell.self, forCellReuseIdentifier: MyProfileReviewTableViewCell.reusableIdentifier)
        view.register(MyProfileImageTableViewCell.self, forCellReuseIdentifier: MyProfileImageTableViewCell.reusableIdentifier)
        view.separatorStyle = .none
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    var dataSource: RxTableViewSectionedReloadDataSource<MyProfileSectionModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCommon(title: "내정보")

        dataSource = RxTableViewSectionedReloadDataSource<MyProfileSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProfileImageTableViewCell.reusableIdentifier, for: indexPath) as? MyProfileImageTableViewCell else { return UITableViewCell() }
                
                return cell
            } else if indexPath.section == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProfileReviewTableViewCell.reusableIdentifier, for: indexPath) as? MyProfileReviewTableViewCell else { return UITableViewCell() }
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProfileTableViewCell.reusableIdentifier, for: indexPath) as? MyProfileTableViewCell else { return UITableViewCell() }
                cell.titleLabel.text = item.title
                cell.setConstraint(index: indexPath.row)
                return cell
            }
   
        })
        let sections = [
            MyProfileSectionModel(items: [MyProfileModel()]),
            MyProfileSectionModel(items: [MyProfileModel()]),
            MyProfileSectionModel(items: [
            MyProfileModel(title: MyProfileText.gender),
            MyProfileModel(title: MyProfileText.study),
            MyProfileModel(title: MyProfileText.permit),
            MyProfileModel(title: MyProfileText.age),
            MyProfileModel(title: MyProfileText.withdraw)
            ])]
    
        let data = Observable<[MyProfileSectionModel]>.just(sections)
        
        data
            .bind(to: tableView.rx.items(dataSource: dataSource!))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
//        tableView.rx.itemSelected
//            .withUnretained(self)
//            .subscribe { vc, index in
//                if index.row == 0 {
//                    vc.transition(MyProfileViewController(), transitionStyle: .push)
//                }
//            }
//            .disposed(by: disposeBag)
    }
    
    override func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
    }


}

extension MyProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 195
        } else if indexPath.section == 1 {
            return 58
        } else {
            switch MyProfileIndex(rawValue: indexPath.row) {
            case .gender, .age:
                return 90
            default:
                return 75
            }
        }
    }
}
