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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var errorLabel: UILabel!
    let errorText = "Can't load news"
    let noInternetErrorCode = -1009
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
                    self.showTableWithNews()
                }
            } else {
                DispatchQueue.main.async {
                    self.showErrorLabel(errorCode: getNewsOperation.errorCode)
                }
            }
        }
        operationQueue.addOperation(getNewsOperation)
    }
    
    func showTableWithNews() {
        self.newsTableView.isHidden = false
        self.searchBar.isUserInteractionEnabled = true
        self.newsTableView.reloadData()
    }
    
    func showErrorLabel(errorCode: Int?) {
        self.newsTableView.isHidden = true
        self.searchBar.isUserInteractionEnabled = false
        if let errorCode = errorCode, errorCode == self.noInternetErrorCode {
            self.errorLabel.text = self.errorText + ". There is no Internet connection"
        } else {
            self.errorLabel.text = self.errorText
        }
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
