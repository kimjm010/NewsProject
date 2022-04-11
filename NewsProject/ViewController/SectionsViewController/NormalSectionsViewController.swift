//
//  NormalSectionsViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/08.
//

import UIKit
import CoreData

class NormalSectionsViewController: CommonViewController {

    @IBOutlet weak var newsListTableview: UITableView!
    
    var article: ArticleEntity?
    
    var selectedCategory: String?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = newsListTableview.indexPath(for: cell) {
            if let vc = segue.destination.children.first as? NewsDetailViewController {
                vc.article = articleController.object(at: indexPath)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        articleController.delegate = self
        navigationItem.title = selectedCategory
        
        fetchNews(endPoint: EndPoint.topHeadlines.rawValue,
                  keyWord: nil,
                  category: selectedCategory ?? "business") {
            DispatchQueue.main.async {
                self.newsListTableview.reloadData()
            }
        }
        
        
        do {
            try articleController.performFetch()
        } catch {
            print(error)
        }
    }
}



extension NormalSectionsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return articleController.sections?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = articleController.sections else { return 0 }
        
        return sectionInfo[section].numberOfObjects
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NormalSectionTableViewCell") as! NormalSectionTableViewCell
        
        let article = articleController.object(at: indexPath)
        cell.configure(article: article)
        
        return cell
    }
}




extension NormalSectionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



extension NormalSectionsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        guard let sectionInfo = articleController.sections else { return }
        
        guard indexPaths.contains(where: { $0.row >= sectionInfo[$0.section].numberOfObjects - 5 }) else { return }
        
        fetchNews(endPoint: EndPoint.topHeadlines.rawValue,
                  keyWord: nil,
                  category: selectedCategory) {
            DispatchQueue.main.async {
                self.newsListTableview.reloadData()
            }
        }
    }
}




extension NormalSectionsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        newsListTableview.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let targetIndexPath = newIndexPath {
                newsListTableview.insertRows(at: [targetIndexPath], with: .automatic)
            }
        case .delete:
            if let targetIndexPath = indexPath {
                newsListTableview.deleteRows(at: [targetIndexPath], with: .automatic)
            }
        case .move:
            if let originalIndexPath = indexPath, let targetIndexPath = newIndexPath {
                newsListTableview.deleteRows(at: [originalIndexPath], with: .automatic)
                newsListTableview.insertRows(at: [targetIndexPath], with: .automatic)
            }
        case .update:
            if let targetIndexPath = indexPath {
                newsListTableview.reloadRows(at: [targetIndexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        newsListTableview.endUpdates()
    }
}
