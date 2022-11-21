//
//  SearchViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/16.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard

class SearchViewController: BaseViewController, UIScrollViewDelegate {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        return view
    }()

    lazy var searchBar: UISearchBar = {
        let width = view.frame.width
        let view = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 10, height: 0))
        view.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        return view
    }()
    
    let searchButton: CommonButton = {
        let view = CommonButton()
        view.selectedStyle()
        view.setTitle("새싹 찾기", for: .normal)
        return view
    }()
    
    let disposeBag = DisposeBag()
    let viewModel = SearchViewModel()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, StudyTag>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        navigationBackButton()
        tabBarController?.tabBar.isHidden = true
        
        configureDataSource()
      
        bindViewModel()
        
        selectedCollection()
    }

    override func configureUI() {
        [collectionView, searchButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
extension SearchViewController {
    func selectedCollection() {
      
        collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe { vc, indexPath in
                if indexPath.section == 0 {
                    let study = vc.viewModel.myStudyArr.map({$0.title})
                    let text = vc.viewModel.recommendArr[indexPath.item].title
                    if study.contains(text) {
                        vc.view.makeToast("스터디를 중복해서 등록할 수 없습니다.", position: .center)
                    } else {
                        if vc.viewModel.arrCountLimit() {
                            vc.view.makeToast("8개 이상 스터디를 등록할 수 없습니다.", position: .center)
                        } else {
                            vc.viewModel.myStudyArr.append(StudyTag(title: text))
                            vc.studySnapshot()
                        }
                    }
                } else if indexPath.section == 1 {
                    let study = vc.viewModel.myStudyArr.map({$0.title})
                    let text = vc.viewModel.aroundStudyArr[indexPath.item].title
                    if study.contains(text) {
                        vc.view.makeToast("스터디를 중복해서 등록할 수 없습니다.", position: .center)
                    } else {
                        if vc.viewModel.arrCountLimit() {
                            vc.view.makeToast("8개 이상 스터디를 등록할 수 없습니다.", position: .center)
                        } else {
                            vc.viewModel.myStudyArr.append(StudyTag(title: text))
                            vc.studySnapshot()
                        }
                    }
                } else  {
                    vc.viewModel.myStudyArr.remove(at: indexPath.item)
                    vc.studySnapshot()
                }
        }
        .disposed(by: disposeBag)

        collectionView.rx.didScroll
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { vc, _ in
                vc.searchBar.endEditing(true)
                vc.searchButton.snp.updateConstraints { make in
                    make.bottom.equalTo(vc.view.safeAreaLayoutGuide).inset(16)
                    make.leading.trailing.equalToSuperview().inset(16)
                }
                vc.searchButton.layer.cornerRadius = 8
                UIView.animate(withDuration: 0) {
                    vc.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)

    }
}
extension SearchViewController {
    private func bindViewModel() {
        let input = SearchViewModel.Input(viewDidLoadEvent: Observable.just(()), searchTap: searchBar.rx.searchButtonClicked, buttonTap: searchButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        let extra = window!.safeAreaInsets.bottom
        
        output.sesacInfo
            .withUnretained(self)
            .subscribe(onNext: { vc, result in
                result.fromQueueDB.map({$0.studylist}).forEach({vc.viewModel.setAround.append(contentsOf: $0)})
                
                result.fromQueueDBRequested.map({$0.studylist}).forEach({vc.viewModel.setAround.append(contentsOf: $0)})
                
                let around = Array(Set(vc.viewModel.setAround))
                                   
                around.forEach { vc.viewModel.aroundStudyArr.append(StudyTag(title: $0)) }

                result.fromRecommend.forEach { vc.viewModel.recommendArr.append(StudyTag(title: $0))}

                vc.studySnapshot()
            })
            .disposed(by: disposeBag)
  
        output.networkFailed
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] error in
                guard let self = self else {return}
                if error == true {
                    self.view.makeToast("사용자의 정보를 불러오는데 실패했습니다.")
                }
            }).disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive (onNext: { [weak self] height in
                guard let self = self else {return}
                UIView.animate(withDuration: 0) {
                    self.searchButton.snp.updateConstraints { make in
                        make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(height - extra)
                        make.leading.trailing.equalToSuperview()
                    }
                    self.searchButton.layer.cornerRadius = 0
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        bindSearchReturnTap(output: output)
        bindSearchButtonTap(output: output)
    }
    
    private func bindSearchReturnTap(output: SearchViewModel.Output) {
        output.searchTap
            .withUnretained(self)
            .bind { vc, _ in
                guard let text = vc.searchBar.text else {return}
                let separatedText = text.components(separatedBy: " ").filter {$0 != ""}
                let result = separatedText.map({StudyTag(title: $0)})
                
                let study = vc.viewModel.myStudyArr.map({$0.title})
                
                if separatedText.filter({$0.count > 8}).count != 0 {
                    vc.view.makeToast("최소 한 자 이상, 최대 8글자까지 작성 가능합니다", position: .center)
                } else  if separatedText.filter({ study.contains($0)}).count != 0 || separatedText.count != Set(separatedText).count {
                    vc.view.makeToast("스터디를 중복해서 등록할 수 없습니다.", position: .center)
                } else {
                    if vc.viewModel.arrCountLimit() {
                        vc.view.makeToast("8개 이상 스터디를 등록할 수 없습니다.", position: .center)
                    } else {
                        vc.viewModel.myStudyArr.append(contentsOf: result)
                        vc.studySnapshot()
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindSearchButtonTap(output: SearchViewModel.Output) {
        output.buttonTap
            .throttle(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { vc, _ in
                vc.requestUser()
            }
            .disposed(by: disposeBag)
    }
}

extension SearchViewController {
    private func requestUser() {
        viewModel.requestSeSACUser { [weak self] value in
            guard let self = self else {return}
            switch StatusCode(rawValue: value) {
            case .success:
                let vc = TabManSeSACViewController()
                vc.firstVC.viewModel.locationValue = self.viewModel.locationValue
                self.transition(vc, transitionStyle: .push)
            case .declarationOrMatch:
                self.view.makeToast("신고가 누적되어 이용하실 수 없습니다", position: .center)
            case .cancelFirst:
                self.view.makeToast("스터디 취소 패널티로, 1분동안 이용하실 수 없습니다", position: .center)
            case .cancelSecond:
                self.view.makeToast("스터디 취소 패널티로, 2분동안 이용하실 수 없습니다", position: .center)
            case .cancelThird:
                self.view.makeToast("스터디 취소 패널티로, 3분동안 이용하실 수 없습니다", position: .center)
            case .firebaseError:
                self.renewalUser()
            default:
                print(value)
                self.view.makeToast("에러가 발생했습니다.", position: .center)
            }
        }
    }
    
    private func renewalUser() {
        viewModel.renewalSeSACUserRequest {
            self.requestUser()
        }
    }
}

extension SearchViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        // UICollectionViewCompositionalLayoutSectionProvider
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
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
                    NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top )
                ]
             
                return section
            } else if sectionIndex == 1 {
                let size = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(35))

                let item = NSCollectionLayoutItem(layoutSize: size)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(35))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                group.interItemSpacing = .fixed(8)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
                return section
            } else {
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
                
                return section
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        layout.configuration = config
        
        return layout
    }
    
    
    private func configureDataSource() {
        
        let otherCellRegistration = UICollectionView.CellRegistration<SearchOtherStudyCollectionViewCell, StudyTag> { cell, indexPath, itemIdentifier in
            cell.studyLabel.text = itemIdentifier.title
            if indexPath.section == 0 {
                cell.outlineBorder(color: UIColor.errorRed.cgColor)
                cell.studyLabel.textColor = .errorRed
            } else {
                cell.outlineBorder(color: UIColor.gray4.cgColor)
                cell.studyLabel.textColor = .black
            }
            
        }
        
        
        let myCellRegistration = UICollectionView.CellRegistration<SearchMyStudyCollectionViewCell, StudyTag> { cell, indexPath, itemIdentifier in
            cell.studyLabel.text = itemIdentifier.title
            cell.outlineBorder()
        }
        
        let headerRegitration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { headerView, elementKind, indexPath in
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = indexPath.section == 0 ? "지금 주변에는" : "내가 하고 싶은"
             
            configuration.textProperties.font = UIFont.notoSans(size: 12, family: .Regular)
            configuration.textProperties.color = .black
            headerView.contentConfiguration = configuration
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            if indexPath.section == 2 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: myCellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            } else {
                let cell = collectionView.dequeueConfiguredReusableCell(using: otherCellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            }
            
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] headerView, elementKind, indexPath in
            return self?.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegitration, for: indexPath)
        }
    }
    
    private func studySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, StudyTag>()
        snapshot.appendSections([0, 1, 2])
        snapshot.appendItems(viewModel.recommendArr, toSection: 0)
        snapshot.appendItems(viewModel.aroundStudyArr, toSection: 1)
        snapshot.appendItems(viewModel.myStudyArr, toSection: 2)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


