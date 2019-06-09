//
//  ViewController.swift
//  SheepAppsTest
//
//  Created by Polina Dulko on 6/9/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let operationQueue = OperationQueue()
        let getNewsOperation = GetNewsOperation()
        getNewsOperation.completionBlock = {
            if getNewsOperation.didFinishWithError == false, let news = getNewsOperation.news {
                print(news)
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

