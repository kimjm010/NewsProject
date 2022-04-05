//
//  CovidViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/29.
//

import UIKit
import iOSDropDown

class CovidViewController: CommonViewController {
    
    @IBOutlet weak var countryDropDown: DropDown!
    
    @IBOutlet weak var covidNewsListTableView: UITableView!
    
    var selectedCountry: String?
    
    
    @IBAction func selectCountry(_ sender: Any) {
        guard let index = countryDropDown.selectedIndex else { return }
        selectedCountry = countryDropDown.optionArray[index]
        
        fetchNews(endPoint: endPoint,
                  country: selectedCountry ?? nil,
                  keyWord: "Covid",
                  category: nil,
                  language: language) {
            DispatchQueue.main.async {
                self.covidNewsListTableView.reloadData()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = covidNewsListTableView.indexPath(for: cell) {
            if let vc = segue.destination as? CovidNewsDetailViewController {
                vc.article = list[indexPath.row]
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNews(endPoint: endPoint,
                  country: nil,
                  keyWord: "Covid",
                  category: nil,
                  language: language) {
            DispatchQueue.main.async {
                self.covidNewsListTableView.reloadData()
            }
        }
        

        countryDropDown.optionArray = ["ae", "ar", "at", "au", "be", "bg", "us", "ru"]
        
    }
}



extension CovidViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CovidTableViewCell") as! CovidTableViewCell
        
        let article = list[indexPath.row]
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
        guard indexPaths.contains(where: { $0.row >= list.count - 5 }) else { return }
        
        fetchNews {
            DispatchQueue.main.async {
                self.covidNewsListTableView.reloadData()
            }
        }
    }
}
