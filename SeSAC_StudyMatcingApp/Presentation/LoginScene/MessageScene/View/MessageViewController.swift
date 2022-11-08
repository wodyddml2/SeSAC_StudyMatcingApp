//
//  MessageViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/07.
//

import UIKit

class MessageViewController: BaseViewController {
let mainView = MessageView()
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arrow")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow")
    }

}
