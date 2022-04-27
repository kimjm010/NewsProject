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
        isSelected = isSelected ? false : true
        isMarkedBtn.image = isSelected ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        usertemp.userIsMarked = isSelected ? true : false
        
        NotificationCenter.default.post(name: .sendIsMarkedNews, object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        guard let newsStr = article?.url, let newsUrl = URL(string: newsStr) else { return }
        let request = URLRequest(url: newsUrl)
        webView.load(request)
    }
}
