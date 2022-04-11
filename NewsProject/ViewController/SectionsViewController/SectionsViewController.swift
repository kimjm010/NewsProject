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
            if let vc = segue.destination.children.first as? NormalSectionsViewController {
                vc.selectedCategory = DataManager.shared.newsCategoryList[indexPath.row]
            }
            if let vc = segue.destination.children.first as? NewsDetailViewController {
                vc.article = articleController.object(at: indexPath)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleController.delegate = self
        
        self.fetchNews(endPoint: EndPoint.topHeadlines.rawValue,
                       keyWord: nil,
                       category: "business") {
            DispatchQueue.main.async {
                self.categoryNewsListTableView.reloadData()
            }
        }
        
        
        // TODO: CoreData 공부하기
        // TODO: CollectionView prefetch 공부하기
        
        do {
            try articleController.performFetch()
        } catch {
            print(error)
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
        
        return DataManager.shared.newsCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 || indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionsTableViewCell") as! SectionsTableViewCell
            let article = articleController.object(at: indexPath)
            cell.categoryTitleLabel.text = DataManager.shared.newsCategoryList[indexPath.row]
            cell.configure(article: article)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "normalCategoryCell")
        let categoryData = DataManager.shared.newsCategoryList
        cell?.textLabel?.text = categoryData[indexPath.row]
        
        
        return cell ?? UITableViewCell()
    }
}




extension SectionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        var bounds = collectionView.bounds
        bounds.size.height += bounds.origin.y
        
        var width = bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
        var height = bounds.height - (layout.sectionInset.bottom + layout.sectionInset.top)
        
        switch layout.scrollDirection {
        case .horizontal:
            width = (width - (layout.minimumLineSpacing * 4)) / 5
            if indexPath.item > 0 {
                height = (height - (layout.minimumInteritemSpacing * 2)) / 3
            }
        default:
            break
        }
        
        return CGSize(width: width, height: height)
        
    }
}




extension SectionsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let sectionInfo = articleController.sections else { return }
        
        guard indexPaths.contains(where: { $0.row >= sectionInfo[$0.section].numberOfObjects - 5 }) else { return }
        
        for category in 0..<DataManager.shared.newsCategoryList.count {
            let categoryList = DataManager.shared.newsCategoryList
            fetchNews(endPoint: EndPoint.topHeadlines.rawValue,
                      keyWord: nil,
                      category: categoryList[category]) {
                DispatchQueue.main.async {
                    self.categoryNewsListTableView.reloadData()
                }
            }
        }
    }
}





extension SectionsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        categoryNewsListTableView.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let targetIndexPath = newIndexPath {
                categoryNewsListTableView.insertRows(at: [targetIndexPath], with: .automatic)
            }
        case .delete:
            if let targetIndexPath = indexPath {
                categoryNewsListTableView.deleteRows(at: [targetIndexPath], with: .automatic)
            }
        case .move:
            if let originalIndexPath = indexPath, let targetIndexPath = newIndexPath {
                categoryNewsListTableView.deleteRows(at: [originalIndexPath], with: .automatic)
                categoryNewsListTableView.insertRows(at: [targetIndexPath], with: .automatic)
            }
        case .update:
            if let targetIndexPath = indexPath {
                categoryNewsListTableView.reloadRows(at: [targetIndexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        categoryNewsListTableView.endUpdates()
    }
}
