//
//  NewsDetailViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/08.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var article: ArticleEntity?
    
    @IBAction func openInSafari(_ sender: Any) {
        guard let newsStr = article?.url, let url = URL(string: newsStr) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        guard let newsStr = article?.url, let newsUrl = URL(string: newsStr) else { return }
        let request = URLRequest(url: newsUrl)
        webView.load(request)
    }
}
