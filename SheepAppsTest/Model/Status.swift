//
//  Status.swift
//  SheepAppsTest
//
//  Created by Polina Dulko on 6/9/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Foundation

struct Status: Decodable {
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case status
    }
}
