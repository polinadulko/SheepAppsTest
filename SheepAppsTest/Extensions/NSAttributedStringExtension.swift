//
//  NSAttributedStringExtension.swift
//  SheepAppsTest
//
//  Created by Polina Dulko on 6/10/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    func replaceWithHyperink(substring: String, with hyperlink: String, url: URL, font: UIFont) -> NSAttributedString {
        let attributedSourceStr = NSMutableAttributedString(attributedString: self)
        let attributedHyperlink = NSAttributedString(string: hyperlink, attributes: [NSAttributedString.Key.link: url, NSAttributedString.Key.font: font])
        let substringRange = (self.string as NSString).range(of: substring)
        attributedSourceStr.replaceCharacters(in: substringRange, with: attributedHyperlink)
        return attributedSourceStr
    }
}
