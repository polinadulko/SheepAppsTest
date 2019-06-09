//
//  LoadImageOperation.swift
//  SheepAppsTest
//
//  Created by Polina Dulko on 6/9/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation
import UIKit

class LoadImageOperation: AsynchronousOperation {
    var urlStr = ""
    var image: UIImage?
    
    init(url: String) {
        super.init()
        urlStr = url
    }
    
    override func main() {
        guard let url = URL(string: urlStr) else {
            self.state = .finished
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                self.image = UIImage(data: data)
            }
            self.state = .finished
        }
        dataTask.resume()
    }
}
