//
//  TodayViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/29.
//

import UIKit

class TodayViewController: UIViewController {
    
    @IBOutlet weak var newsListTableview: UITableView!
    
    var list = [NewsList.Article]()
    var page = 0
    var hasMore = true
    var isFetching = false

    func fetchNews() {
        guard hasMore && !isFetching else { return }
        
        page += 1
        isFetching = true
        
        let urlStr = "https://newsapi.org/v2/everything?q=latest&from=2022-03-29&sortBy=popularity&apiKey=741b9390ed4f4c189c0e0a45378e9db1&page=\(page)"
        
        guard let url = URL(string: urlStr) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            
            defer {
                self.isFetching = false
            }
            
            if let error = error {
                self.hasMore = false
                print(error)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print((response as? HTTPURLResponse)?.statusCode)
                self.hasMore = false
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(NewsList.self, from: data)
                
                self.list.append(contentsOf: result.articles)
                self.hasMore = result.articles.count > 0
                
                DispatchQueue.main.async {
                    self.newsListTableview.reloadData()
                }
                
            } catch {
                self.hasMore = false
                print(error)
            }
        }
        
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchNews()
    }

}




extension TodayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell") as? TodayNewsTableViewCell
        
        let target = list[indexPath.row]
        cell?.configure(article: target)
        
        return cell ?? UITableViewCell()
    }
}




extension TodayViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print(#function)
        guard indexPaths.contains(where: { $0.row >= self.list.count - 5 }) else { return }
        
        fetchNews()
    }
}




extension TodayViewController: UITableViewDelegate {
    
}
