//
//  NewsList.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/03/28.
//

import Foundation

struct NewsList: Codable {
    let status: String
    let totalResult: Int?
    
    struct Article: Codable {
        struct Source: Codable {
            let id: String?
            let name: String
        }
        
        let source: Source
        let author: String?
        let title: String
        let description: String
        let url: String
        let urlToImage: String?
        let publishedAt: Date
        let content: String?
        let isMarked: Bool = false
    }
    
    let articles: [Article]
    
}


enum EndPoint: String, CaseIterable {
    case everything = "everything"
    case topHeadlines = "top-headlines"
}
