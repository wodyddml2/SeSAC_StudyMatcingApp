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
    
    let saveButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "저장", style: .plain, target: MyProfileViewController.self, action: nil)
        
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    let viewModel = MyProfileViewModel()
    
    var dataSource: RxTableViewSectionedReloadDataSource<MyProfileSectionModel>?
    
    var autoBool: Bool = false
    var sesacData: SeSACProfileGet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        view.addSubview(tableView)
        navigationBarCommon(title: "정보 관리")
        navigationItem.rightBarButtonItem = saveButton
        tabBarController?.tabBar.isHidden = true
       
        bindViewModel()
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func setTableView(sesacInfo: SeSACProfileGet, output: MyProfileViewModel.Output) {
        
        dataSource = RxTableViewSectionedReloadDataSource<MyProfileSectionModel>(configureCell: { [weak self] dataSource, tableView, indexPath, item in
            guard let self = self else {return UITableViewCell()}
            
            switch ProfileSection(rawValue: indexPath.section) {
            case .image:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProfileImageTableViewCell.reusableIdentifier, for: indexPath) as? MyProfileImageTableViewCell else { return UITableViewCell() }
                cell.sesacBackgroundImageView.image = .sesacBackgroundImage(num: item.backgroundImage)
                cell.sesacImageView.image = .sesacImage(num: item.image)
                return cell
            case .review:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProfileReviewTableViewCell.reusableIdentifier, for: indexPath) as? MyProfileReviewTableViewCell else { return UITableViewCell() }
                cell.sesacReviewImageView.image = self.autoBool ? UIImage(systemName: "chevron.up")! : UIImage(systemName: "chevron.down")!
                cell.setData(item: item)
                return cell
            case .info:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProfileTableViewCell.reusableIdentifier, for: indexPath) as? MyProfileTableViewCell else { return UITableViewCell() }
                
                cell.setData(item: item)
                
                cell.genderView.womanButton.rx.tap
                    .withUnretained(self)
                    .bind { vc, _ in
                    cell.genderView.womanButton.selectedStyle()
                    cell.genderView.manButton.normalStyle()
                    vc.sesacData?.gender = cell.genderView.womanButton.tag
                }
                .disposed(by: self.disposeBag)
                
                cell.genderView.manButton.rx.tap
                    .withUnretained(self)
                    .bind { vc, _ in
                    cell.genderView.womanButton.normalStyle()
                    cell.genderView.manButton.selectedStyle()
                    vc.sesacData?.gender = cell.genderView.manButton.tag
                }
                .disposed(by: self.disposeBag)
                
                cell.studyView.studyTextField.rx.text
                    .orEmpty
                    .withUnretained(self)
                    .bind { vc, value in
                        vc.sesacData?.study = value
                    }
                    .disposed(by: self.disposeBag)
                
                cell.permitView.permitSwitch.rx.isOn
                    .withUnretained(self)
                    .bind { vc, value in
                        vc.sesacData?.searchable = value ? 1 : 0
                    }
                    .disposed(by: self.disposeBag)
                
                cell.ageView.ageSlider.rx.controlEvent(.valueChanged)
                    .withUnretained(self)
                    .bind { vc, _ in
                        let sliderValue = cell.ageView.ageSlider.value
                        cell.ageView.ageLabel.text = "\(Int(sliderValue[0]))-\(Int(sliderValue[1]))"
                        vc.sesacData?.ageMax = Int(sliderValue[1])
                        vc.sesacData?.ageMin = Int(sliderValue[0])
                    }
                    .disposed(by: self.disposeBag)
                
                cell.withdrawView.withdrawButton.rx.tap
                    .withUnretained(self)
                    .bind { vc, _ in
                        let viewController = WithdrawViewController()
                        vc.transition(viewController, transitionStyle: .presentOverFull)
                    }
                    .disposed(by: self.disposeBag)
                
                return cell
            default:
                return UITableViewCell()
            }
        })
        
        
        let sections = [
            MyProfileSectionModel(items: [SeSACProfileGet(
                backgroundImage: sesacInfo.backgroundImage,
                image: sesacInfo.image)]),
            MyProfileSectionModel(items: [SeSACProfileGet(
                nickname: sesacInfo.nickname,
                sesacTitle: sesacInfo.sesacTitle,
                comment: sesacInfo.comment)]),
            MyProfileSectionModel(items: [SeSACProfileGet(
                
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
        let input = MyProfileViewModel.Input(viewDidLoadEvent: Observable.just(()), save: saveButton.rx.tap)
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
                vc.sesacData = sesac
                vc.setTableView(sesacInfo: sesac, output: output)
                vc.bindSave(output: output)
            }
            .disposed(by: disposeBag)
    }
    
    
    func bindSave(output: MyProfileViewModel.Output) {
        output.save
            .withUnretained(self)
            .bind { vc, _ in
                guard let sesacData = vc.sesacData else {return}
                
                SeSACAPIService.shared.requestSeSACAPI(type: SESACLoginDTO.self ,router: Router.savePut(sesac: sesacData, query: UserManager.idToken)) { result in
                    switch result {
                    case .success(_):
                        print("String 출력")
                    case .failure(let fail):
                        let error = fail as! SeSACError
                        switch error {
                        case .success:
                            vc.view.makeToast("저장 완료!", position: .center)
                        default:
                            vc.view.makeToast("저장에 실패했습니다.", position: .center)
                        }
                    }
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    
    
}
