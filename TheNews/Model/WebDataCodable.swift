//
//  WebDataCodable.swift
//  TheNews
//
//  Created by MD SAZID HASAN DIP on 29/8/20.
//  Copyright © 2020 MD SAZID HASAN DIP. All rights reserved.
//

import Foundation
struct WebDataCodable: Codable {
    let status: String
    let totalResults: Int
    let articles: [Articles]
    
}

struct Articles: Codable {

    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    let source: Source?
    
}

struct Source: Codable {
    let id: String?
    let name: String
}



struct ArticleInfo{

    let author: String
    let title: String
    let descrp: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
    let sourceName: String
    let image: Data
    
}
