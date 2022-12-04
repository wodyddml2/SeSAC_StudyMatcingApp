//
//  BgShopViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/30.
//

import UIKit

class BgShopViewController: BaseViewController {
    
    let tableView: UITableView = {
        let view = UITableView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
