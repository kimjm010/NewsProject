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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configure(article: NewsList.Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        publishedDateLabel.text = article.publishedAt
        
        guard let image = UIImage(contentsOfFile: article.urlToImage) else { return }
        newsImageView.image = image
    }
}
