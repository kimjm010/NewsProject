//
//  CommonDataManager.swift
//  NewsProject
//
//  Created by Chris Kim on 4/22/22.
//

import Foundation
import CoreData

// TODO: User CoreData 셋업하기
// TODO: userNotification 등록하기
// TODO: Apple 로그인 구현하기
// TODO: textSize 조정하기



class CommonDataManager {
    
    static let shared = CommonDataManager()
    private init() { }
    
    let newsCategoryList = ["Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]
    
    var user = [UserEntity]()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var fetchRequestArticleEntity: NSFetchRequest<ArticleEntity> {
        let request = ArticleEntity.fetchRequest()
        
        let sortByDateDesc = NSSortDescriptor(key: "publishedAt", ascending: false)
        let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortByDateDesc, sortByTitle]
        request.fetchBatchSize = 10
        return request
    }
    
    var fetchRequestUserEntity: NSFetchRequest<UserEntity> {
        let request = UserEntity.fetchRequest()
        
        return request
    }
    
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsDB")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() {
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
