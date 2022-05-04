//
//  CommonViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/30.
//

import Foundation
import UIKit
import CoreData


class CommonViewController: UIViewController {
    
    var tokens = [NSObjectProtocol]()
    
    var signinUser: User?
    
    var page = 0
    
    var hasMore = true
    
    var isFetching = false
    
    lazy var articleController: NSFetchedResultsController<ArticleEntity> = {
        let controller = NSFetchedResultsController(fetchRequest: CommonDataManager.shared.fetchRequestArticleEntity,
                                                    managedObjectContext: CommonDataManager.shared.mainContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }()
    
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(forName: .sendUserName, object: nil, queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            guard let user = noti.userInfo?["user"] as? User else { return }
            self.signinUser = user
        }
    }
    
    
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    func fetchNews(endPoint: String,
                   keyWord: String?,
                   category: String?,
                   completion: (() -> ())? = nil) {
        guard hasMore && !isFetching else { return }
        
        page += 1
        
        isFetching = true
        
        var urlStr = ""
        
        if let keyWord = keyWord {
            urlStr = "https://newsapi.org/v2/\(endPoint)?q=\(keyWord)&apiKey=741b9390ed4f4c189c0e0a45378e9db1&page=\(page)&language=en"
            if let category = category {
                urlStr = "https://newsapi.org/v2/\(endPoint)?q=\(keyWord)&apiKey=741b9390ed4f4c189c0e0a45378e9db1&category=\(category)&page=\(page)&language=en"
            }
        }
        
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
                decoder.dateDecodingStrategy = .iso8601
                let result = try decoder.decode(NewsList.self, from: data)
                
                self.hasMore = result.articles.count > 0
                
                if result.articles.count > 0 {
                    DispatchQueue.main.async {
                        CommonDataManager.shared.addArticle(list: result.articles)
                        
                    }
                }
                
                completion?()
            } catch {
                self.hasMore = false
                print(error)
            }
        }
        
        task.resume()
    }
    
    
    func transitionToMainVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyBoard.instantiateViewController(withIdentifier: "MainViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(mainVC)
    }
}

