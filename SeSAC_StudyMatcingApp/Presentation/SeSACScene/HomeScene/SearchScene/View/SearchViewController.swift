//
//  SearchViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/16.
//

import UIKit

struct ResultString: Hashable {
    let study: String
}

class SearchViewController: BaseViewController {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.delegate = self
        return view
    }()

    lazy var searchBar: UISearchBar = {
        let width = view.frame.width
        let view = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 20, height: 0))
        view.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        view.delegate = self
        return view
    }()
    
//    lazy var a = [ResultString(study: "Ss")]
    var ace: [String] = []
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        navigationBackButton()
        configureDataSource()
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(ace)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    override func configureUI() {
        view.addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    

}

extension SearchViewController {
//    private func searchControllerSet() {
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//    }
    
    private func createLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(35))

        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        
        // boundarySupplementaryItems: 머리글 및 바닥글과 같이 섹션의 경계 가장자리와 연결된 보충 항목의 배열
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
     
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = config
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, String> { cell, indexPath, itemIdentifier in
            cell.studyButton.setTitle(itemIdentifier, for: .normal)
            print(itemIdentifier)
        }
        
        let headerRegitration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { headerView, elementKind, indexPath in
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = "내가 하고 싶은"
            configuration.textProperties.font = UIFont.notoSans(size: 12, family: .Regular)
            configuration.textProperties.color = .black
            headerView.contentConfiguration = configuration
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] headerView, elementKind, indexPath in
            return self?.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegitration, for: indexPath)
        }
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
}

extension SearchViewController: UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) { }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        ace.append(searchBar.text!)
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(ace)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
//    func removeDuplicate (_ array: [Int]) -> [Int] {
//        var removedArray = [Int]()
//        for i in array {
//            if removedArray.contains(i) == false {
//                removedArray.append(i)
//            }
//        }
//    }
}
