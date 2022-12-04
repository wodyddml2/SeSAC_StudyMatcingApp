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
    
    let viewModel = ShopViewModel()
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
    }
}

extension SeSACShopViewController {
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            print("인앱 결제 가능")
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
        
        print(receiptString)
        //거래 내역(transaction)을 큐에서 제거
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
                product = i // 옵션. 테이블 뷰 셀에서 구매하기 버튼 클릭 시, 버튼 클릭 시
                sections[0].items.append(ShopModel(name: i.localizedTitle, info: i.localizedDescription, price: commaFormat(price: i.price)))
                
                viewModel.sesacSections.onNext(sections)
                print(i.localizedTitle, i.price, i.priceLocale, i.localizedDescription)
            }
            
        } else {
            print("No Product Found") // 계약 업데이트, 유료 계약 X, Capablities X
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case .purchased: //구매 승인 이후에 영수증 검증
                print("Transaction Approved. \(transaction.payment.productIdentifier)")
                receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
                
            case .failed: //실패 토스트, transaction
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                
            default:
                break
            }
        }
    }
}


