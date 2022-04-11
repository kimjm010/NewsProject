//
//  NormalSectionTableViewCell.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/08.
//

import UIKit

class NormalSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    func configure(article: ArticleEntity) {
        titleLabel.text = article.title
        descriptionLabel.text = article.explanation
        guard let publishedDate = article.publishedAt else { return }
        dateLabel.text = publishedDate.dateToString
        
        DispatchQueue.global().async {
            guard let imageStr = article.urlToImage,
                  let imageUrl = URL(string: imageStr),
                  let imageData = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                self.newsImageView.image = UIImage(data: imageData)
            }
        }
    }
}
