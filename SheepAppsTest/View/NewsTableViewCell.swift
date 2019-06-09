//
//  NewsTableViewCell.swift
//  SheepAppsTest
//
//  Created by Polina Dulko on 6/9/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var previewImageView: UIImageView!
    
    var article: Article? {
        didSet {
            guard let article = article, let title = article.title, let urlToImage = article.urlToImage else { return }
            titleLabel.text = title
            if let image = ImagesCache.shared().object(forKey: urlToImage as AnyObject) {
                DispatchQueue.main.async {
                    self.previewImageView.image = image
                }
            } else {
                let operationQueue = OperationQueue()
                operationQueue.qualityOfService = .utility
                let loadImageOperation = LoadImageOperation(url: urlToImage)
                loadImageOperation.completionBlock = {
                    if let image = loadImageOperation.image {
                        DispatchQueue.main.async {
                            self.previewImageView.image = image
                        }
                        ImagesCache.shared().setObject(image, forKey: urlToImage as AnyObject)
                    }
                }
                operationQueue.addOperation(loadImageOperation)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
