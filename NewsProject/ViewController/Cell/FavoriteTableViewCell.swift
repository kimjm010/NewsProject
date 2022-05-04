//
//  FavoriteTableViewCell.swift
//  NewsProject
//
//  Created by Chris Kim on 4/30/22.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var markedImageView: UIImageView!
    
    @IBOutlet weak var markedNewsTitle: UILabel!
    
    @IBOutlet weak var markedNewsImageView: UIImageView!
    
    @IBOutlet weak var markedNewsDescription: UILabel!
    
    @IBOutlet weak var markedNewsDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    
    func configure(article: ArticleEntity, completion: (() -> ())? = nil) {
        // TODO: markedImageView ArticleEntity에 추가할 것!
        markedNewsTitle.text = article.title
        markedNewsDate.text = article.publishedAt?.dateToString
        markedNewsDescription.text = article.explanation
        
        DispatchQueue.global().async {
            guard let imageStr = article.urlToImage,
                  let imageUrl = URL(string: imageStr),
                  let imageData = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                self.markedNewsImageView.image = UIImage(data: imageData)
            }
        }
        
        completion?()
    }

}
