//
//  FavoriteViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/29.
//

import UIKit
import CoreData

class FavoriteViewController: CommonViewController {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = favoriteTableView.indexPath(for: cell) {
            if let vc = segue.destination.children.first as? NewsDetailViewController {
                let article = CommonDataManager.shared.markedNewsList[indexPath.row]
                vc.article = article
            }
        }
    }
}




extension FavoriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommonDataManager.shared.markedNewsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell") as! FavoriteTableViewCell
        
        let article = CommonDataManager.shared.markedNewsList[indexPath.row]
        cell.configure(article: article, completion: nil)
        
        return cell
    }
}




extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
