//
//  TodayViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/29.
//

import UIKit

class TodayViewController: CommonViewController {
    
    @IBOutlet weak var newsListTableview: UITableView!
    
    
    var filteredList = [NewsList.Article]()
    
    lazy var updateTableView = {
        DispatchQueue.main.async {
            self.newsListTableview.reloadData()
        }
    }
    
    var target: NewsList.Article?
    
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
            if let vc = segue.destination as? TodayNewsDetailViewController {
                vc.target = list[indexPath.row]
            }
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchNews {
            DispatchQueue.main.async {
                self.newsListTableview.reloadData()
            }
        }
        setupSearchController()
    }

    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Please enter a search word."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        filteredList = list.filter { (article) -> Bool in
            return article.content.lowercased().contains(searchText.lowercased())
        }
        
        newsListTableview.reloadData()
    }
}




extension TodayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredList.count
        }
        
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayNewsTableViewCell") as! TodayNewsTableViewCell
        
        var article: NewsList.Article
        
        if isFiltering {
            article = filteredList[indexPath.row]
        } else {
            article = list[indexPath.row]
        }
        
        cell.configure(article: article)
        return cell
    }
}




extension TodayViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard indexPaths.contains(where: { $0.row >= list.count - 5 }) else { return }
        
        fetchNews {
            DispatchQueue.main.async {
                self.newsListTableview.reloadData()
            }
        }
    }
}




extension TodayViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        target = list[indexPath.row]
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
