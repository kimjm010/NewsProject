//
//  TodayNewsDetailViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/29.
//

import UIKit
import WebKit

class TodayNewsDetailViewController: UIViewController {
    
    @IBOutlet weak var newsWebView: WKWebView!
    
    var target: NewsList.Article?
    
    
    @IBAction func openInSafari(_ sender: Any) {
        if let str = target?.url, let url = URL(string: str) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let str = target?.url, let url = URL(string: str) {
            let request = URLRequest(url: url)
            newsWebView.load(request)
        }
        
    }
    
}
