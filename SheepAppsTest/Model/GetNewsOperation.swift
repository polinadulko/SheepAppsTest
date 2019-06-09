//
//  GetNewsOperation.swift
//  SheepAppsTest
//
//  Created by Polina Dulko on 6/9/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation

class GetNewsOperation: AsynchronousOperation {
    let urlStr = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(newsApiKey)"
    var news: Articles?
    var didFinishWithError = true
    var errorCode: Int?
    
    override func main() {
        guard let url = URL(string: urlStr) else {
            self.state = .finished
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error as NSError? {
                self.errorCode = error.code
            } else if let data = data, let status = try? JSONDecoder().decode(Status.self, from: data), let statusText = status.status, statusText == "ok" {
                self.news = try? JSONDecoder().decode(Articles.self, from: data)
                self.didFinishWithError = false
            }
            self.state = .finished
        }
        dataTask.resume()
    }
}
