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
        var isMarked: Bool = false
    }
    
    let articles: [Article]
}


let newsCategoryList = ["Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]
let newsLanguageList = ["ae","ar","at","au","be","bg","br","ca","ch","cn","co","cu","cz","de","eg","fr","gb","gr","hk","hu","id","ie","il","in","it","jp","kr","lt","lv","ma","mx","my","ng","nl","no","nz","ph","pl","pt","ro","rs","ru","sa","se","sg","si","sk","th","tr","tw","ua","us","ve","za"]


