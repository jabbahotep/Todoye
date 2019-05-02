//
//  Item.swift
//  Todoye
//
//  Created by admin on 30/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var completed: Bool = false
    @objc dynamic var createdAt: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
