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

class SeSACFindViewController: BaseViewController {
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(SeSACFindImageTableViewCell.self, forCellReuseIdentifier: SeSACFindImageTableViewCell.reusableIdentifier)
        view.register(SeSACFindReviewTableViewCell.self, forCellReuseIdentifier: SeSACFindReviewTableViewCell.reusableIdentifier)
        return view
    }()
    
    let viewModel = SeSACFindViewModel()
    let disposeBag = DisposeBag()
    
    var dataSources: RxTableViewSectionedReloadDataSource<SeSACFindSectionModel>?

    var autoBool: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func configureUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
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
                cell.sesacReviewImageView.image = self.autoBool ? UIImage(systemName: "chevron.up")! : UIImage(systemName: "chevron.down")!
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
            .bind(to: tableView.rx.items(dataSource: dataSources!))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe { vc, index in
                if index.row == 1 {
                    vc.autoBool.toggle()
                    vc.tableView.reloadRows(at: [IndexPath(row: index.row, section: index.section)], with: .fade)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    
}

extension SeSACFindViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch SeSACFindRow(rawValue: indexPath.row) {
        case .image:
            return 225
        case .review:
            return autoBool ? UITableView.automaticDimension : 58
        default:
            return 0
        }
    }
}

extension SeSACFindViewController {
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
