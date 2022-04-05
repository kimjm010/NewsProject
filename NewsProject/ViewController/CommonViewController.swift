//
//  CommonViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/30.
//

import Foundation
import UIKit


class CommonViewController: UIViewController {
    
    var list = [NewsList.Article]()
    var page = 0
    var hasMore = true
    var isFetching = false
    
    var endPoint = "top-headlines"
    var country = "us"
    var keyWord = "today"
    var category = "business"
    var language = "en"
    
    func fetchNews(endPoint: String = "top-headlines",
                   country: String? = "us",
                   keyWord: String = "today",
                   category: String? = "business",
                   language: String = "en",
                   completion: (() -> ())? = nil) {
        guard hasMore && !isFetching else { return }
        
        page += 1
        isFetching = true
        var urlStr = ""
        if let country = country, let category = category {
            urlStr = "https://newsapi.org/v2/\(endPoint)?country=\(country)&q=\(keyWord)&apiKey=741b9390ed4f4c189c0e0a45378e9db1&category=\(category)&page=\(page)&language=\(language) "
        }
        
        urlStr = "https://newsapi.org/v2/\(endPoint)?q=\(keyWord)&apiKey=741b9390ed4f4c189c0e0a45378e9db1&page=\(page)&language=\(language) "
        
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
                print((response as? HTTPURLResponse)?.statusCode ?? 0)
                self.hasMore = false
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(NewsList.self, from: data)
                
                self.list.append(contentsOf: result.articles)
                self.hasMore = result.articles.count > 0
                completion?()
            } catch {
                self.hasMore = false
                print(error)
            }
        }
        
        task.resume()
    }
}
