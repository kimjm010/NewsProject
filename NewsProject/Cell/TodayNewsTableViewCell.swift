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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
//    func configure(article: NewsList.Article) {
//        titleLabel.text = article.title
//        descriptionLabel.text = article.description
//        publishedDateLabel.text = article.publishedAt.dateToString
//
//        DispatchQueue.global().async {
//            guard let urlToImageStr = article.urlToImage,
//                  let imageUrl = URL(string: urlToImageStr),
//                  let imageData = try? Data(contentsOf: imageUrl) else { return }
//            DispatchQueue.main.async {
//                self.newsImageView.image = UIImage(data: imageData)
//            }
//        }
//    }
    
    func configure(article: ArticleEntity) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
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
