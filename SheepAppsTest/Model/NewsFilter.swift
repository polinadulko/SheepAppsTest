//
//  NewsFilter.swift
//  SheepAppsTest
//
//  Created by Polina Dulko on 6/9/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation

class NewsFilter {
    var news = [Article]()
    
    init(news: [Article]) {
        self.news = news
    }
    
    func filterBySource(source: String) -> [Article] {
        var result = [Article]()
        for article in news {
            if article.sourceName?.lowercased() == source.lowercased() {
                result.append(article)
            }
        }
        return result
    }
}
