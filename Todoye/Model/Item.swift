//
//  Item.swift
//  Todoye
//
//  Created by admin on 24/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class Item {
    var title : String
    var completed : Bool
    
    init(itemTitle: String, itemCompleted: Bool) {
        title = itemTitle
        completed = itemCompleted
    }
}
