//
//  Item.swift
//  Todoye
//
//  Created by admin on 24/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class Item: Codable {
    var title : String = ""
    var completed : Bool = false
    
    init(itemTitle: String) {
        title = itemTitle
    }
}
