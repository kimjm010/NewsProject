//
//  CovidNewsDetailViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/31.
//

import UIKit
import WebKit

class CovidNewsDetailViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var bookMarkBtn: UIBarButtonItem!
    
    var article: NewsList.Article?
    
    var isMarked = false
    
    
    @IBAction func toggleBookMark(_ sender: Any) {
        print(#function)
    }
    
    
    @IBAction func openInSafari(_ sender: Any) {
        guard let urlStr = article?.url,  let url = URL(string: urlStr) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let urlStr = article?.url,  let url = URL(string: urlStr) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
