//
//  UserModel.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/29.
//

import Foundation
import CoreLocation


struct User {
    let name: String
    var isCompleted: Bool = false
    var isReminder: Bool = false
    var reminderType: ReminderType = .timeInterval
    var timeInterval: TimeInterval?
    var date: Date?
    var lat: Double?
    var lon: Double?
    var radius: Double?
}


enum ReminderType: Int {
    case timeInterval = 0
    case calendar
    case location
}


let generalSettingLists = ["Push Notification Settings", "DisplaySetting"]

//["Log Out", "About This App"]



struct UserTemp {
    let name: String
}



