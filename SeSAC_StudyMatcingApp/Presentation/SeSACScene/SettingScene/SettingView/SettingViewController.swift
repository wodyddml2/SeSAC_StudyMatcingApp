//
//  ProfileViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/12.
//

import UIKit

import RxDataSources
import RxSwift
import RxCocoa

enum SettingImage {
    static let notice = "notice"
    static let faq = "faq"
    static let qna = "qna"
    static let alarm = "alarm"
    static let permit = "permit"
}

enum SettingText {
    static let notice = "공지사항"
    static let faq = "자주 묻는 질문"
    static let qna = "1:1 문의"
    static let alarm = "알림 설정"
    static let permit = "이용약관"
}

final class SettingViewController: BaseViewController {

    let tableView: UITableView = {
        let view = UITableView()
        view.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.reusableIdentifier)
        view.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reusableIdentifier)
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    var dataSource: RxTableViewSectionedReloadDataSource<SettingSectionModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCommon(title: "내정보")
        dataSource = RxTableViewSectionedReloadDataSource<SettingSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reusableIdentifier, for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
                cell.separatorInset = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 15)
                cell.profileImage.image = item.leftImage
                cell.profileLabel.text = item.title
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reusableIdentifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
                
                cell.separatorInset = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 15)
                cell.iconImage.image = item.leftImage
                cell.settingLabel.text = item.title
                return cell
            }
            
        })
        let sections = SettingSectionModel(items: [
            SettingModel(leftImage: .sesacImage(num: UserManager.sesacImage ?? 0), title: UserManager.nickname),
            SettingModel(leftImage: .commonImage(name: SettingImage.notice), title: SettingText.notice),
            SettingModel(leftImage: .commonImage(name: SettingImage.faq), title: SettingText.faq),
            SettingModel(leftImage: .commonImage(name: SettingImage.qna), title: SettingText.qna),
            SettingModel(leftImage: .commonImage(name: SettingImage.alarm), title: SettingText.alarm),
            SettingModel(leftImage: .commonImage(name: SettingImage.permit), title: SettingText.permit)
            ])
    
        let data = Observable<[SettingSectionModel]>.just([sections])
        
        data
            .bind(to: tableView.rx.items(dataSource: dataSource!))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe { vc, index in
                if index.row == 0 {
                    vc.transition(MyProfileViewController(), transitionStyle: .push)
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    

}

extension SettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 96 : 74
    }
}
