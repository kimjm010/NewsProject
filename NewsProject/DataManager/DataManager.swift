//
//  DataManager.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/05.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    private init() { }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    func addArticle(list: [NewsList.Article]) {
        for article in list {
            add(article: article)
        }
        
        saveContext()
    }
    
    
    var fetchRequest: NSFetchRequest<ArticleEntity> {
        let request = ArticleEntity.fetchRequest()
        
        let sortByDateDesc = NSSortDescriptor(key: "publishedAt", ascending: false)
        let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortByDateDesc, sortByTitle]
        request.fetchBatchSize = 10
        return request
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
    
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsDB")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
