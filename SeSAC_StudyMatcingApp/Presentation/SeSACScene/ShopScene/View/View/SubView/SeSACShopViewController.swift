//
//  SeSACShopViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/30.
//

import UIKit

import RxSwift
import RxDataSources

class SeSACShopViewController: BaseViewController {

    let disposeBag = DisposeBag()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(SeSACShopCollectionViewCell.self, forCellWithReuseIdentifier: SeSACShopCollectionViewCell.reusableIdentifier)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private var dataSources: RxCollectionViewSectionedReloadDataSource<ShopSectionModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollecionView()
  
    }
    
    override func configureUI() {
        view.addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

extension SeSACShopViewController {
   
}

extension SeSACShopViewController: UICollectionViewDelegate {
    private func setCollecionView() {
        dataSources = RxCollectionViewSectionedReloadDataSource<ShopSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeSACShopCollectionViewCell.reusableIdentifier, for: indexPath) as? SeSACShopCollectionViewCell else {return UICollectionViewCell()}
            cell.sesacLabel.text = item.name
            cell.sesacInfoLabel.text = item.info
            cell.sesacPriceButton.setTitle(item.price, for: .normal)
            cell.sesacImageView.image = .sesacImage(num: indexPath.item)
            return cell
        })
        
        var sections: [ShopSectionModel] = [ShopSectionModel(items: [])]
        
        for value in SeSAC.allCases {
            sections[0].items.append(ShopModel(name: value.name, info: value.info, price: value.price))
        }
        
        let data = Observable<[ShopSectionModel]>.just(sections)
        
        data
            .bind(to: collectionView.rx.items(dataSource: dataSources!))
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = view.frame.width / 2 - 16
        
        layout.itemSize = CGSize(width: width - 4, height: width * 1.691)
        layout.sectionInset.bottom = 24
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        return layout
    }
}
