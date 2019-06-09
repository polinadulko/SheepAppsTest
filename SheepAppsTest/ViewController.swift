//
//  ViewController.swift
//  SheepAppsTest
//
//  Created by Polina Dulko on 6/9/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    let newsCellReuseIdentifier = "NewsCell"
    var news: [Article]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.dataSource = self
        newsTableView.tableFooterView = UIView(frame: .zero)
        
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .utility
        let getNewsOperation = GetNewsOperation()
        getNewsOperation.completionBlock = {
            if getNewsOperation.didFinishWithError == false, let news = getNewsOperation.news {
                self.news = news.articles
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                }
            } else {
                let getNewsErrorText = "Error of loading news"
                if let errorCode = getNewsOperation.errorCode {
                    NSLog("%@ (code = %d)", getNewsErrorText, errorCode)
                } else {
                    NSLog(getNewsErrorText)
                }
            }
        }
        operationQueue.addOperation(getNewsOperation)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let news = news {
            return news.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: newsCellReuseIdentifier) as! NewsTableViewCell
        if let news = news {
            cell.article = news[indexPath.row]
        }
        return cell
    }
}
