//
//  SeSACShopViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/30.
//

import UIKit
import StoreKit

import RxSwift
import RxDataSources

class SeSACShopViewController: BaseViewController {

    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(SeSACShopCollectionViewCell.self, forCellWithReuseIdentifier: SeSACShopCollectionViewCell.reusableIdentifier)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private var dataSources: RxCollectionViewSectionedReloadDataSource<ShopSectionModel>?
    
    let viewModel = SeSACShopViewModel()
    let disposeBag = DisposeBag()
    
    var productIdentifiers: Set<String> = ["com.memolease.sesac1.sprout1", "com.memolease.sesac1.sprout2", "com.memolease.sesac1.sprout3", "com.memolease.sesac1.sprout4"]
    
    var productArray = Array<SKProduct>()
    var product: SKProduct?
    
    var sections: [ShopSectionModel] = [ShopSectionModel(items: [ShopModel(name: SeSAC.allCases[0].name, info: SeSAC.allCases[0].info, price: SeSAC.allCases[0].price)])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollecionView()
        bindViewModel()
        requestProductData()
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
    private func bindViewModel() {
        viewModel.sesacSections
            .bind(to: collectionView.rx.items(dataSource: dataSources!))
            .disposed(by: disposeBag)
 
        viewModel.myInfo
            .withUnretained(self)
            .subscribe { vc, result in
                vc.viewModel.sesacCollection.onNext(result.sesacCollection)
            }
            .disposed(by: disposeBag)
        
        viewModel.infoFailed
            .asDriver()
            .drive (onNext: { [weak self] error in
                guard let self = self else {return}
                if error == true {
                    self.view.makeToast("사용자의 정보를 불러오는데 실패했습니다.")
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SeSACShopViewController {
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            print("In App Purchase Not Enabled")
        }
    }
    
    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
     
        if let product = product?.productIdentifier {
            viewModel.requestiOS(receipt: receiptString ?? "", product: product)
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

extension SeSACShopViewController: UICollectionViewDelegate {
    private func setCollecionView() {
        dataSources = RxCollectionViewSectionedReloadDataSource<ShopSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeSACShopCollectionViewCell.reusableIdentifier, for: indexPath) as? SeSACShopCollectionViewCell else {return UICollectionViewCell()}
            cell.sesacLabel.text = item.name
            cell.sesacInfoLabel.text = item.info
            cell.sesacPriceButton.setTitle(item.price, for: .normal)
            cell.sesacImageView.image = .sesacImage(num: indexPath.item)
            cell.sesacPriceButton.rx.tap
                .withUnretained(self)
                .bind { vc, _ in
                    if indexPath.item > 0 && !vc.viewModel.sesacArr.contains(indexPath.item) {
                        vc.product = vc.productArray[indexPath.row - 1]
                        let payment = SKPayment(product: vc.productArray[indexPath.item - 1])
                        SKPaymentQueue.default().add(payment)
                        SKPaymentQueue.default().add(self)
                    }
                }
                .disposed(by: cell.disposeBag)
            return cell
        })
        
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

extension SeSACShopViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    func commaFormat(price: NSDecimalNumber) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: price)!
    }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        
        if products.count > 0 {
            for i in products {
                productArray.append(i)
                sections[0].items.append(ShopModel(name: i.localizedTitle, info: i.localizedDescription, price: commaFormat(price: i.price)))
            }
            viewModel.sesacCollection.onNext(viewModel.sesacArr)
            viewModel.sesacCollection
                .withUnretained(self)
                .subscribe { vc, values in
                    vc.viewModel.sesacArr = values
                    for value in values {
                        vc.sections[0].items[value].price = "보유"
                    }
                    vc.viewModel.sesacSections.onNext(vc.sections)
                }
                .disposed(by: disposeBag)
        } else {
            view.makeToast("상품을 준비중입니다.", position: .center)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case .purchased: //구매 승인 이후에 영수증 검증
                receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
                
            case .failed: //실패 토스트, transaction
                view.makeToast("구매를 취소했습니다.", position: .center)
                SKPaymentQueue.default().finishTransaction(transaction)
                
            default:
                break
            }
        }
    }
}


