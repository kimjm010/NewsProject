//
//  TodayNewsTableViewCell.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/29.
//

import UIKit

class TodayNewsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var publishedDateLabel: UILabel!
    
    
    func configure(article: ArticleEntity) {
        titleLabel.text = article.title
        descriptionLabel.text = article.explanation
        guard let publishedDate = article.publishedAt else { return }
        publishedDateLabel.text = publishedDate.dateToString
        
        DispatchQueue.global().async {
            guard let urlToImageStr = article.urlToImage,
                  let imageUrl = URL(string: urlToImageStr),
                  let imageData = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                self.newsImageView.image = UIImage(data: imageData)
            }
        }
    }
}
