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
    let hyperlinkRegexPattern = "\\[\\+[0-9]+ chars\\]"
    
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
        if let article = article, let content = article.content, let urlStr = article.url {
            if let strToReplace = getTextToReplaceWithLink(text: content), let url = URL(string: urlStr) {
                let font = UIFont.systemFont(ofSize: 17.0)
                articleTextView.attributedText = NSAttributedString(string: content, attributes: [NSAttributedString.Key.font: font]).replaceWithHyperink(substring: strToReplace, with: strToReplace, url: url, font: font)
            } else {
                articleTextView.text = content
            }
        } else {
            articleTextView.text.removeAll()
        }
    }
    
    func getTextToReplaceWithLink(text: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: hyperlinkRegexPattern)
            let results = regex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
            let result = results.map { String(text[Range($0.range, in: text)!]) }.first
            return result
        } catch { }
        return nil
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
