//
//  UserModel.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/29.
//

import Foundation


struct user {
    let id: UUID
    let userName: String
    let userIsMarked: Bool
}


// UserDefault에 저장할 것
enum PushNotiSettings: Int {
    case today = 0
    case covid = 1
}



struct DisplaySettings {
    var theme: Bool
    var systemTextSize: Bool
    var customTextSize: Double
}

//enum DisplaySettings: Int {
//    case theme = 0
//    case systemTextSize = 1
//    case customTextSize = 2
//}


