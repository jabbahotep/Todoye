//
//  Category.swift
//  Todoye
//
//  Created by admin on 30/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

