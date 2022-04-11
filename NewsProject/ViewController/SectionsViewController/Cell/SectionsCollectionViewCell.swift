//
//  SectionsCollectionViewCell.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/06.
//

import UIKit

class SectionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    @IBOutlet weak var categoryNewsImageView: UIImageView!
    
    @IBOutlet weak var categoryNewsTitleLabel: UILabel!
    
    
    
    func configure(article: ArticleEntity) {
        categoryNewsTitleLabel.text = article.title
        
        DispatchQueue.global().async {
            guard let urlToImageStr = article.urlToImage,
                  let imageUrl = URL(string: urlToImageStr),
                  let imageData = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                self.categoryNewsImageView.image = UIImage(data: imageData)
            }
        }
    }
}
