//
//  ReviewTableViewController.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/22.
//

import UIKit

class ReviewTableViewController: UITableViewController {

    var reviewList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBackButton()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func navigationBackButton() {
        navigationItem.title = "새싹 리뷰"
        navigationController?.navigationBar.tintColor = .black
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.setBackIndicatorImage(UIImage(named: "arrow"), transitionMaskImage: UIImage(named: "arrow"))
        navigationController?.navigationBar.scrollEdgeAppearance = navigationAppearance
        navigationController?.navigationBar.standardAppearance = navigationAppearance
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.notoSans(size: 14, family: .Regular)
        cell.textLabel?.text = reviewList[indexPath.row]
        return cell
    }


}
