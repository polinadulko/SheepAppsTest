//
//  ContentViewController.swift
//  SheepAppsTest
//
//  Created by Polina Dulko on 6/10/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    @IBOutlet var articleImageView: UIImageView!
    @IBOutlet weak var articleTextView: UITextView!
    
    var article: Article? {
        didSet {
            if articleImageView != nil && articleTextView != nil {
                setArticleText()
                setArticleImage()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setArticleText()
        setArticleImage()
    }
    
    func setArticleText() {
        if let article = article, let content = article.content, let url = article.url {
            articleTextView.text = content + "\n\n" + url
        }
    }
    
    func setArticleImage() {
        guard let article = article, let urlToImage = article.urlToImage else { return }
        if let image = ImagesCache.shared().object(forKey: urlToImage as AnyObject) {
            DispatchQueue.main.async {
                self.articleImageView.image = image
            }
        } else {
            let operationQueue = OperationQueue()
            operationQueue.qualityOfService = .utility
            let loadImageOperation = LoadImageOperation(url: urlToImage)
            loadImageOperation.completionBlock = {
                if let image = loadImageOperation.image {
                    DispatchQueue.main.async {
                        self.articleImageView.image = image
                    }
                    ImagesCache.shared().setObject(image, forKey: urlToImage as AnyObject)
                } else {
                    DispatchQueue.main.async {
                        self.articleImageView.image = nil
                    }
                }
            }
            operationQueue.addOperation(loadImageOperation)
        }
    }
}
