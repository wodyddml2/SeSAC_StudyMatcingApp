//
//  BirthViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/10.
//

import UIKit

final class BirthViewController: BaseViewController {
    
    let mainView = BirthView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserManager.nickname) 
        navigationBackButton()
       
    }
    

}
