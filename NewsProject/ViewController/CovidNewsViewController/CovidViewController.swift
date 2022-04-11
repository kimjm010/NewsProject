//
//  CovidViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/29.
//

import UIKit
import iOSDropDown
import CoreData

class CovidViewController: CommonViewController {
    
    
    @IBOutlet weak var covidNewsListTableView: UITableView!
    
    var selectedCountry: String?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = covidNewsListTableView.indexPath(for: cell) {
            if let vc = segue.destination.children.first as? NewsDetailViewController {
                vc.article = articleController.object(at: indexPath)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleController.delegate = self
        
        fetchNews(endPoint: EndPoint.everything.rawValue,
                  keyWord: "Covid",
                  category: nil) {
            DispatchQueue.main.async {
                self.covidNewsListTableView.reloadData()
            }
        }
        
        
        do {
            try articleController.performFetch()
        } catch {
            print(error)
        }
    }
}



extension CovidViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return articleController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = articleController.sections else { return 0 }
        return sectionInfo[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CovidTableViewCell") as! CovidTableViewCell
        
        let article = articleController.object(at: indexPath)
        cell.configure(article: article)
        
        return cell
    }
}





extension CovidViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension CovidViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let sectionInfo = articleController.sections else { return }
        guard indexPaths.contains(where: { $0.row >= sectionInfo[$0.section].numberOfObjects - 5 }) else { return }
        
        fetchNews(endPoint: EndPoint.everything.rawValue,
                  keyWord: "Covid",
                  category: nil) {
            DispatchQueue.main.async {
                self.covidNewsListTableView.reloadData()
            }
        }
    }
}




extension CovidViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        covidNewsListTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let targetIndexPath = newIndexPath {
                covidNewsListTableView.insertRows(at: [targetIndexPath], with: .automatic)
            }
        case .delete:
            if let taretIndexPath = indexPath {
                covidNewsListTableView.deleteRows(at: [taretIndexPath], with: .automatic)
            }
        case .move:
            if let originalIndexPath = indexPath, let targetIndexPath = newIndexPath {
                covidNewsListTableView.deleteRows(at: [originalIndexPath], with: .automatic)
                covidNewsListTableView.insertRows(at: [targetIndexPath], with: .automatic)
            }
        case .update:
            if let targetIndexPath = indexPath {
                covidNewsListTableView.reloadRows(at: [targetIndexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        covidNewsListTableView.endUpdates()
    }
}
