//
//  Extension.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/05.
//

import Foundation

fileprivate let formatter = DateFormatter()

extension Date {
    var dateToString: String {
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
}
