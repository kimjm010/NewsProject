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
        newArticle.isMarked = article.isMarked
    }
    
    
    func fetchArticle() {
        mainContext.performAndWait {
            let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
            let sortByDateAsc = NSSortDescriptor(key: "publishedAt", ascending: false)
            request.sortDescriptors = [sortByDateAsc]

            do {
                newsList = try mainContext.fetch(request)
            } catch {
                print(error.localizedDescription, "fetchArticle에서 에러발생했어요!!")
            }
        }
    }
    
    
    func updateIsMarkedButton(article: ArticleEntity,
                              isMakred: Bool,
                              completion: (() ->())? = nil) {
        mainContext.perform {
            let newArticle = ArticleEntity(context: self.mainContext)
            article.isMarked = newArticle.isMarked
            
            self.saveContext()
            completion?()
        }
    }
}
