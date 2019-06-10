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
    let contentSegueIdentifier = "ContentSegue"
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var errorLabel: UILabel!
    let errorText = "Can't load news"
    let noInternetErrorCode = -1009
    var initialNews: [Article]?
    var news: [Article]?
    var newsFilter: NewsFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        newsTableView.dataSource = self
        newsTableView.tableFooterView = UIView(frame: .zero)
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(loadNews))
        swipeGestureRecognizer.direction = .down
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        self.view.isUserInteractionEnabled = true
        
        loadNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func loadNews() {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == contentSegueIdentifier, let news = news, let indexPathOfSelectedRow = newsTableView.indexPathForSelectedRow {
            let destination = segue.destination as! ContentViewController
            let selectedArticle = news[indexPathOfSelectedRow.row]
            destination.article = selectedArticle
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == contentSegueIdentifier, let news = news, let indexPathOfSelectedRow = newsTableView.indexPathForSelectedRow {
            let article = news[indexPathOfSelectedRow.row]
            if article.content != nil {
                return true
            }
        }
        return false
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

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func endNewsFiltering() {
        searchBar.showsCancelButton = false
        searchBar.text?.removeAll()
        searchBar.resignFirstResponder()
        news = initialNews
        DispatchQueue.main.async {
            self.newsTableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        if let news = news {
            initialNews = news
            newsFilter = NewsFilter(news: news)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        endNewsFiltering()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        endNewsFiltering()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let newsFilter = newsFilter {
            self.news = newsFilter.filterBySource(source: searchText)
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        }
    }
}
