//
//  ImagesCache.swift
//  SheepAppsTest
//
//  Created by Polina Dulko on 6/9/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation
import UIKit

class ImagesCache {
    private static var imagesCache = NSCache<AnyObject,UIImage>()
    
    private init() { }
    
    static func shared() -> NSCache<AnyObject,UIImage> {
        return imagesCache
    }
}
