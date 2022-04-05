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

    
    func configure(article: NewsList.Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        publishedDateLabel.text = article.publishedAt
        
        guard let urlToImageStr = article.urlToImage,
              let imageUrl = URL(string: urlToImageStr),
              let imageData = try? Data(contentsOf: imageUrl) else { return }
        newsImageView.image = UIImage(data: imageData)

    }
}
