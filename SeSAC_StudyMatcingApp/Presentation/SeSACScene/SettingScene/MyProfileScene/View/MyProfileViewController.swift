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
        bindViewModel()
        
        
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func setTableView(sesacInfo: SeSACProfile) {
        dataSource = RxTableViewSectionedReloadDataSource<MyProfileSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            switch ProfileSection(rawValue: indexPath.section) {
            case .image:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProfileImageTableViewCell.reusableIdentifier, for: indexPath) as? MyProfileImageTableViewCell else { return UITableViewCell() }
                cell.sesacBackgroundImageView.image = .sesacBackgroundImage(num: item.backgroundImage)
                cell.sesacImageView.image = .sesacImage(num: item.image)
                return cell
            case .review:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProfileReviewTableViewCell.reusableIdentifier, for: indexPath) as? MyProfileReviewTableViewCell else { return UITableViewCell() }
                cell.nicknameLabel.text = item.nickname
                cell.reviewView.sesacReviewLabel.text = item.comment.first
                cell.configureReputation(reputation: item.sesacTitle)
                return cell
            case .info:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProfileTableViewCell.reusableIdentifier, for: indexPath) as? MyProfileTableViewCell else { return UITableViewCell() }
                
                cell.configureGender(gender: item.gender)
                
                cell.studyView.studyTextField.text = item.study
                
                cell.configurePermit(permit: item.searchable)
                
                cell.ageView.ageLabel.text = "\(item.ageMin)-\(item.ageMax)"
                cell.ageView.ageSlider.value = [CGFloat(item.ageMin), CGFloat(item.ageMax)]
                cell.ageView.ageSlider.rx.controlEvent(.valueChanged)
                    .bind { _ in
                        let sliderValue = cell.ageView.ageSlider.value
                        cell.ageView.ageLabel.text = "\(Int(sliderValue[0]))-\(Int(sliderValue[1]))"
                    }
                    .disposed(by: self.disposeBag)
                return cell
            default:
                return UITableViewCell()
            }
        })
        
        
        let sections = [
            MyProfileSectionModel(items: [SeSACProfile(
                backgroundImage: sesacInfo.backgroundImage,
                image: sesacInfo.image)]),
            MyProfileSectionModel(items: [SeSACProfile(
                nickname: sesacInfo.nickname,
                sesacTitle: sesacInfo.sesacTitle,
                comment: sesacInfo.comment)]),
            MyProfileSectionModel(items: [SeSACProfile(
                
                gender: sesacInfo.gender,
                study: sesacInfo.study,
                searchable: sesacInfo.searchable,
                ageMin: sesacInfo.ageMin,
                ageMax: sesacInfo.ageMax)])
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
      
        output.networkFailed
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] error in
                guard let self = self else {return}
                if error == true {
                    self.view.makeToast("사용자의 정보를 불러오는데 실패했습니다.")
                }
            }).disposed(by: disposeBag)
        
        output.sesacInfo
            .withUnretained(self)
            .subscribe { vc, sesac in
                print(sesac)
                self.setTableView(sesacInfo: sesac)
            }
            .disposed(by: disposeBag)
    }
}
