//
//  UserModel.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/29.
//

import Foundation
import CoreLocation


//class User: Identifiable, Codable {
//    var id: UUID
//    let userName: String
//    var userIsMarked: Bool
//    var isNoti: Bool
//    var notiDate: Date?
//    var isRepeat: Bool
//    
//    init(id: UUID, userName: String, userIsMarked: Bool = false, isNoti: Bool = false, notiDate: Date, isRepeat: Bool = false) {
//        self.id = id
//        self.userName = userName
//        self.userIsMarked = userIsMarked
//        self.isNoti = isNoti
//        self.notiDate = notiDate
//        self.isRepeat = isRepeat
//    }
//}

// 이 클래스로 하자
class newUserModel {
    var name: String
    var repeats: Bool
    var markedArticleList: [NewsList.Article]
    var reminderType: Int16
    var timeInterval: TimeInterval
    var date: Date
    var lat: Double
    var lon: Double
    var radius: Double
    
    init(name: String,
         repeats: Bool = false,
         isMarked: Bool = false,
         markedArticleList: [NewsList.Article],
         reminderType: Int16,
         timeInterval: TimeInterval,
         date: Date,
         lat: Double,
         lon: Double,
         radius: Double) {
        self.name = name
        self.repeats = repeats
        self.markedArticleList = markedArticleList
        self.reminderType = reminderType
        self.timeInterval = timeInterval
        self.date = date
        self.lat = lat
        self.lon = lon
        self.radius = radius
    }
}


class UserModel: Identifiable, Codable {
    var id = UUID().uuidString
    var name: String
    var userIsMarked: Bool
    var timeInterval: TimeInterval
    var date: Date
    var longitude: Double
    var latitude: Double
    var radius: Double
    var reminderType: Int16
    var repeats = false
    
    init(id: String,
         name: String,
         userIsMarked: Bool = false,
         timeInterval: TimeInterval,
         date: Date,
         longitude: Double,
         latitude: Double,
         radius: Double,
         reminderType: Int16,
         repeats: Bool = false) {
        self.id = id
        self.name = name
        self.userIsMarked = userIsMarked
        self.timeInterval = timeInterval
        self.date = date
        self.longitude = longitude
        self.latitude = latitude
        self.radius = radius
        self.reminderType = reminderType
        self.repeats = repeats
    }
}

enum ReminderType: Int, CaseIterable, Codable {
  case time = 0
  case calendar
  case location
//  var id: Int { self.rawValue }
}

struct Reminder: Codable {
  var timeInterval: TimeInterval?
  var date: Date?
  var location: LocationReminder?
  var reminderType: ReminderType = .time
  var repeats = false
}

struct LocationReminder: Codable {
  var latitude: Double
  var longitude: Double
  var radius: Double
}


// UserDefault에 저장할 것
enum PushNotiSettings: Int {
    case today = 0
    case covid = 1
}


let generalSettingLists = ["Push Notification Settings", "DisplaySetting"]

//["Log Out", "About This App"]






