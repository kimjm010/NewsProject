//
//  NSNotification+Extension.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/12.
//

import Foundation


extension NSNotification.Name {
    
    static let setDarktMode = NSNotification.Name(rawValue: "setDarktMode")
    
    static let initialSettingDisplayMode = NSNotification.Name(rawValue: "initialSettingDisplayMode")
    
    static let sendIsMarkedNews = NSNotification.Name(rawValue: "sendIsMarkedNews")
    
    static let sendSelectedTimeInterval = NSNotification.Name(rawValue: "sendSelectedTimeInterval")
}
