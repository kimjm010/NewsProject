//
//  CovidTableViewCell.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/30.
//

import UIKit

class CovidTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    func configure(article: NewsList.Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        dateLabel.text = article.publishedAt
        guard let urlToImageStr = article.urlToImage,
              let imageUrl = URL(string: urlToImageStr),
              let imageData = try? Data(contentsOf: imageUrl) else { return }
        newsImageView.image = UIImage(data: imageData)
    }
}
