//
//  NotificationManager.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/16.
//

import Foundation
import UserNotifications
import UIKit
import CoreLocation


class NotificationManager {
    
    static let shared = NotificationManager()
    private init() { }
    
    var settings: UNNotificationSettings?
    
    
    /// request Notification Authorization
    /// - Parameter completion: completion which execute after permision is granted
    func requestAuthoriation(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            self.fetchNotificationSettings()
            completion(granted)
        }
    }
    
    
    /// save Notification settings
    func fetchNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }
    
    
    func scheduleNoti(id: String,
                      reminderType: Int,
                      timeInterval: TimeInterval? = nil,
                      date: Date? = nil,
                      latitude: Double? = nil,
                      longitude: Double? = nil,
                      radius: Double? = nil,
                      isReminder: Bool = false,
                      completion: (() -> ())? = nil) {
        let content = UNMutableNotificationContent()
        content.title = "NewsProject"
        content.body = "Please check notification"
        
        var trigger: UNNotificationTrigger?
        
        switch reminderType {
        case 0:
            guard let timeInterval = timeInterval else { return }
            

            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: isReminder)
            print(#function, "등록되었습니다.")
        case 1:
            guard let date = date else { return }
            
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isReminder)
        case 2:
            guard let latitude = latitude,
                  let longitude = longitude,
                  let radius = radius else { return }

            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = CLCircularRegion(center: center, radius: radius, identifier: id)
            trigger = UNLocationNotificationTrigger(region: region, repeats: isReminder)
        default:
            break
        }
        
        if let trigger = trigger {
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print(error, #function, "Notification Manager에서 에러 발생이에요!!!!!")
                }
            }
        }
    }
    
    
    func scheduleNotification(user: User, repeats: Bool) {
        let content = UNMutableNotificationContent()
        content.title = "NewsProject wants to Alert you"
        content.body = "Please check the notification"
        
        
        
        var trigger: UNNotificationTrigger?
        switch user.reminderType {
        case .timeInterval:
            guard let timeInterval = user.timeInterval else { return }
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval , repeats: user.isReminder)
        case .calendar:
            guard let date = user.date else { return }
            trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.month, .day, .year, .hour, .minute], from: date), repeats: user.isReminder)
        case .location:
            guard let lat = user.lat,
                  let lon = user.lon,
                  let radius = user.radius else { return }
            let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let region = CLCircularRegion(center: center, radius: radius, identifier: user.name)
            trigger = UNLocationNotificationTrigger(region: region, repeats: user.isReminder)
        default:
            break
        }
        
        if let trigger = trigger {
            let request = UNNotificationRequest(identifier: user.name,
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print(error, #function, "NotificationManager에서 에러 발생!!!!!!!")
                }
            }
        }
        
    }
    
    
    
    func removeScheduleNotification(user: User) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [user.name])
    }
    
}
