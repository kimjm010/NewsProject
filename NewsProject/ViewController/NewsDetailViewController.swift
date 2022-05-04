//
//  NewsDetailViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/08.
//

import UIKit
import WebKit

class NewsDetailViewController: CommonViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var isMarkedBtn: UIBarButtonItem!
    
    var article: ArticleEntity?
    
    var isSelected: Bool = false
    
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func openInSafari(_ sender: Any) {
        guard let newsStr = article?.url, let url = URL(string: newsStr) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func toggleIsMarked(_ sender: Any) {
        guard let article = article else { return }

        isSelected = isSelected ? false : true
        article.isMarked = isSelected
        isMarkedBtn.image = isSelected ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        
        // TODO: id지정해서 해당 위치에서 article 삭제할 것!!
        if isSelected {
            CommonDataManager.shared.markedNewsList.append(article)
            print(CommonDataManager.shared.markedNewsList.count)
        } else {
            CommonDataManager.shared.markedNewsList.removeLast()
            print(CommonDataManager.shared.markedNewsList.count)
        }
        
        NotificationCenter.default.post(name: .sendIsMarkedNews, object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        guard let newsStr = article?.url,
                let newsUrl = URL(string: newsStr) else { return }
        let request = URLRequest(url: newsUrl)
        webView.load(request)
    }
}
