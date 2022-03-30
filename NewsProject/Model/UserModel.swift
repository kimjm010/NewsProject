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
    let userDisplaySetting: Int
    let userIsMarked: Bool
    let userLocation: Double
    let userNotification: Bool
    let userCategory: Int
}
