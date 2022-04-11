//
//  TodayViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/29.
//

import UIKit
import CoreData


class TodayViewController: CommonViewController {
    
    @IBOutlet weak var newsListTableview: UITableView!
    
    /// NewsList.Article array whcih is filtered by the searched words.
    var filteredList = [ArticleEntity]()
    
    /// selectedArticle
    var selectedArticle: ArticleEntity?
    
    /// to temporarily store the searched text
    var cachedText = ""
    
    /// search manage object
    var searchController = UISearchController(searchResultsController: nil)
    
    /// check status of searchBar
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// Check whether filtering or not
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    
    /// send selected Data to TodayNewsDetailViewController
    /// - Parameters:
    ///   - segue: called segue
    ///   - sender: object which trigger the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = newsListTableview.indexPath(for: cell) {
            if let vc = segue.destination.children.first as? NewsDetailViewController {
                vc.article = articleController.object(at: indexPath)
            }
        }
    }
    
    
    /// called right after the view load to memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleController.delegate = self
        
        // fetch NewsList
        fetchNews(endPoint: EndPoint.everything.rawValue,
                  keyWord: "today",
                  category: nil) {
            DispatchQueue.main.async {
                self.newsListTableview.reloadData()
            }
        }
        
        do {
            try articleController.performFetch()
        } catch {
            print(error)
        }
        
        // call searchController setup method
        setupSearchController()
    }
    
    
    /// setup the searchController object
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Please enter a search word."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    /// conduct search method and store the result to 'filteredList'
    /// - Parameter searchText: text which user want to search it
    func filterContentForSearchText(_ searchText: String) {
        guard let articles = articleController.fetchedObjects else { return }
        
        filteredList = articles.filter({ (article) -> Bool in
            guard let content = article.content else { return false }
            return content.lowercased().contains(searchText.lowercased())
        })
        
        newsListTableview.reloadData()
    }
}




extension TodayViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return articleController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredList.count
        }
        
        guard let sectionInfo = articleController.sections else { return 0 }
        
        return sectionInfo[section].numberOfObjects
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayNewsTableViewCell") as! TodayNewsTableViewCell
        
        var article: ArticleEntity
        
        if isFiltering {
            article = filteredList[indexPath.row]
        } else {
            article = articleController.object(at: indexPath)
        }
        
        cell.configure(article: article)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = articleController.sections else { return "" }
        return sectionInfo[section].name
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return articleController.sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        let result = articleController.section(forSectionIndexTitle: title, at: index)
        return result
    }
}




extension TodayViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        guard let sectionInfo = articleController.sections else { return }
        
        guard indexPaths.contains(where: { $0.row >= sectionInfo[$0.section].numberOfObjects - 5 }) else { return }
        
        fetchNews(endPoint: EndPoint.everything.rawValue,
                  keyWord: "today",
                  category: nil) {
            DispatchQueue.main.async {
                self.newsListTableview.reloadData()
            }
        }
    }
}




extension TodayViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}




extension TodayViewController: UISearchResultsUpdating {
    
    /// called when the searchBar's text changed
    /// - Parameter searchController: searchController object
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else { return }
        
        filterContentForSearchText(text)
    }
}




extension TodayViewController: UISearchBarDelegate {
    
    /// called when the search text changed
    /// - Parameters:
    ///   - searchBar: searchBar which is editing
    ///   - searchText: current text of searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
        cachedText = searchText
    }
    
    
    /// called when the user end to edit the text wich will be searched
    /// - Parameter searchBar: searchBar which is editing
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard !(cachedText.isEmpty || filteredList.isEmpty) else { return }
        searchController.searchBar.text = cachedText
    }
    
    
    /// Called when 'Return' or the 'Search' button clicked
    /// - Parameter searchBar: searchBar which is editing
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = true
    }
}




extension TodayViewController: NSFetchedResultsControllerDelegate {
    
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
