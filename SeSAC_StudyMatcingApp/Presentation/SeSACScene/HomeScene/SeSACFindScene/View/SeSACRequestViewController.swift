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
    
    let viewModel = SeSACFindViewModel()
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
        
        heightChange = Array(repeating: false, count: sections.count)
    }
    
    func noSeSACHidden(bool: Bool) {
        mainView.sesacImageView.isHidden = bool
        mainView.titleLabel.isHidden = bool
        mainView.subTitleLabel.isHidden = bool
        mainView.changeButton.isHidden = bool
        mainView.reloadButton.isHidden = bool
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
        let input = SeSACFindViewModel.Input(viewDidLoadEvent: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        output.sesacInfo
            .withUnretained(self)
            .subscribe (onNext: { vc, sesacInfo in
                vc.setTableView(sesacInfo: sesacInfo)
            })
            .disposed(by: disposeBag)
    }
}
