//
//  UserModel.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/29.
//

import Foundation


struct User {
    let id: UUID
    let userName: String
    let userIsMarked: Bool
    let userNoti: Date
}


// UserDefault에 저장할 것
enum PushNotiSettings: Int {
    case today = 0
    case covid = 1
}


let generalSettingLists = ["Push Notification Settings", "DisplaySetting"]

//["Log Out", "About This App"]






