//
//  UserDataManager.swift
//  NewsProject
//
//  Created by Chris Kim on 4/22/22.
//

import Foundation
import CoreData
import UIKit

    

    // TODO: user CoreData 셋업
    // TODO: userNotification 등록하기


//extension CommonDataManager {
//    
//    func createUser(name: String,
//                    date: Date? = nil,
//                    userIsMakred: Bool = false,
//                    repeats: Bool = false,
//                    reminderType: Int16? = nil,
//                    timeInterval: TimeInterval? = nil,
//                    latitude: Double? = nil,
//                    longitude: Double? = nil,
//                    radius: Double? = nil,
//                    completion: (() -> ())? = nil) {
//        mainContext.perform {
//            let newUser = UserEntity(context: self.mainContext)
//            newUser.name = name
//            newUser.userIsMarked = userIsMakred
//            newUser.repeats = repeats
//            
//            self.user.append(newUser)
//            
//            self.saveContext()
//            completion?()
//        }
//    }
//    
//    
//    
//    
//    
//    func updateTimeIntervalReminder(user: UserEntity,
//                                    reminderType: Int16,
//                                    timeInterval: TimeInterval,
//                                    completion: (() ->())? = nil) {
//        mainContext.perform {
//            let newUser = UserEntity(context: self.mainContext)
//            
//            newUser.reminderType = reminderType
//            newUser.timeInterval = timeInterval
//            
//            self.saveContext()
//            completion?()
//        }
//    }
//    
//    
//    func updateDateReminder(user: UserEntity,
//                            reminderType: Int16,
//                            date: Date,
//                            completion: (() -> ())? = nil) {
//        mainContext.perform {
//            let newUser = UserEntity(context: self.mainContext)
//            
//            newUser.reminderType = reminderType
//            newUser.date = date
//            
//            self.saveContext()
//            completion?()
//        }
//    }
//    
//    
//    func updateLocationReminder(user: UserEntity,
//                    reminderType: Int16,
//                    longitude: Double,
//                    latitude: Double,
//                    radius: Double,
//                    completion: (() -> ())? = nil) {
//        mainContext.perform {
//            let newUser = UserEntity(context: self.mainContext)
//            
//            newUser.reminderType = reminderType
//            newUser.longitude = longitude
//            newUser.latitude = latitude
//            newUser.radius = radius
//            
//            self.saveContext()
//            completion?()
//        }
//    }
//}
