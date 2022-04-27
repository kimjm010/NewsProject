//
//  DataManager.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/05.
//

import Foundation
import CoreData



extension CommonDataManager {
    
    func addArticle(list: [NewsList.Article]) {
        for article in list {
            add(article: article)
        }
        
        saveContext()
    }
    
    
    private func add(article: NewsList.Article) {
        let request = ArticleEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "title == %@", article.title)
        request.resultType = .countResultType
        
        let cnt = try? mainContext.count(for: request)
        guard cnt == 0 else { return }
        
        let newArticle = ArticleEntity(context: mainContext)
        newArticle.title = article.title
        newArticle.explanation = article.description
        newArticle.url = article.url
        newArticle.urlToImage = article.urlToImage
        newArticle.publishedAt = article.publishedAt
        newArticle.content = article.content
    }
}
