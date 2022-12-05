//
//  BgShopViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/30.
//

import UIKit
import StoreKit

import RxSwift
import RxDataSources

class BgShopViewController: BaseViewController {
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(BgShopTableViewCell.self, forCellReuseIdentifier: BgShopTableViewCell.reusableIdentifier)
        view.showsVerticalScrollIndicator = false
        view.rowHeight = 165
        view.separatorStyle = .none
        return view
    }()
    
    private var dataSources: RxTableViewSectionedReloadDataSource<ShopSectionModel>?
    
    let viewModel = SeSACShopViewModel()
    let disposeBag = DisposeBag()
    
    var productIdentifiers: Set<String> = ["com.memolease.sesac1.background1", "com.memolease.sesac1.background2", "com.memolease.sesac1.background3", "com.memolease.sesac1.background4", "com.memolease.sesac1.background5", "com.memolease.sesac1.background6", "com.memolease.sesac1.background7"]
    
    var productArray = Array<SKProduct>()
    var product: SKProduct?
    var sections: [ShopSectionModel] = [ShopSectionModel(items: [ShopModel(name: SeSACBackground.allCases[0].name, info: SeSACBackground.allCases[0].info, price: SeSACBackground.allCases[0].price)])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        bindViewModel()
        requestProductData()
    }
    
    override func configureUI() {
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

extension BgShopViewController {
    private func bindViewModel() {
        viewModel.sesacSections
            .bind(to: tableView.rx.items(dataSource: dataSources!))
            .disposed(by: disposeBag)
 
        viewModel.myInfo
            .withUnretained(self)
            .subscribe { vc, result in
                vc.viewModel.backgroundCollection.onNext(result.backgroundCollection)
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

extension BgShopViewController {
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

extension BgShopViewController: UITableViewDelegate {
    private func setTableView() {
        dataSources = RxTableViewSectionedReloadDataSource<ShopSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BgShopTableViewCell.reusableIdentifier, for: indexPath) as? BgShopTableViewCell else {return UITableViewCell()}
            cell.sesacLabel.text = item.name
            cell.sesacInfoLabel.text = item.info
            cell.sesacPriceButton.setTitle(item.price, for: .normal)
            cell.sesacImageView.image = .sesacBackgroundImage(num: indexPath.row)
            cell.sesacPriceButton.rx.tapGesture()
                .when(.recognized)
                .withUnretained(self)
                .bind { vc, _ in
                    if indexPath.item > 0 && !vc.viewModel.sesacArr.contains(indexPath.row) {
                        vc.product = vc.productArray[indexPath.row - 1]
                        let payment = SKPayment(product: vc.productArray[indexPath.row - 1])
                        SKPaymentQueue.default().add(payment)
                        SKPaymentQueue.default().add(self)
                    }
                }
                .disposed(by: cell.disposeBag)
            return cell
        })
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    
    }
}

extension BgShopViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
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
            viewModel.backgroundCollection.onNext(viewModel.sesacArr)
            viewModel.backgroundCollection
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
