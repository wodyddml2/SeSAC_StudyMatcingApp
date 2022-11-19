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

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func configureUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }

    func setTableView(sesacInfo: SeSACSearchDTO) {
        dataSources = RxTableViewSectionedReloadDataSource<SeSACFindSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            switch SeSACFindRow(rawValue: indexPath.row) {
            case .image:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SeSACFindImageTableViewCell.reusableIdentifier, for: indexPath) as? SeSACFindImageTableViewCell else {return UITableViewCell()}
                
                return cell
            case .review:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SeSACFindReviewTableViewCell.reusableIdentifier, for: indexPath) as? SeSACFindReviewTableViewCell else {return UITableViewCell()}
                
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
