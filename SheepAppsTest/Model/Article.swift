//
//  Article.swift
//  SheepAppsTest
//
//  Created by Polina Dulko on 6/9/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation

struct Source: Decodable {
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

struct Article: Decodable {
    var sourceName: String?
    var title: String?
    var urlToImage: String?
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        case source
        case title
        case urlToImage
        case content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let source = try? container.decode(Source.self, forKey: .source)
        self.sourceName = source?.name
        self.title = try? container.decode(String.self, forKey: .title)
        self.urlToImage = try? container.decode(String.self, forKey: .urlToImage)
        self.content = try? container.decode(String.self, forKey: .content)
    }
}
