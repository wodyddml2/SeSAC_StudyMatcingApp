//
//  ReviewViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/25.
//

import UIKit

class SeSACReviewViewController: UIViewController {

    let mainView = SeSACReviewView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.5)
    }

}
