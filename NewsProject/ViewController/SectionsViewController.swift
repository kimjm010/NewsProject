//
//  SectionsViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/29.
//

import UIKit
import CoreData

class SectionsViewController: CommonViewController {
    
    @IBOutlet weak var categoryNewsListTableView: UITableView!
    
    var selectedCategory: String?

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = categoryNewsListTableView.indexPath(for: cell) {
            if let vc = segue.destination.children.first as? TodayViewController {
                vc.selectedCategory = CommonDataManager.shared.newsCategoryList[indexPath.row]
            }
        }
    }
}




extension SectionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}




extension SectionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommonDataManager.shared.newsCategoryList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionsTableViewCell")
        let categoryList = CommonDataManager.shared.newsCategoryList
        cell?.textLabel?.text = categoryList[indexPath.row]
        
        return cell ?? UITableViewCell()
    }
}
