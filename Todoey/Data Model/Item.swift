//
//  Item.swift
//  Todoey
//
//  Created by John Ure on 23/01/2018.
//  Copyright © 2018 Soft Touch. All rights reserved.
//

import Foundation
import RealmSwift

// class for Realm Object, needs Obj-C and dynamic so Realm can monitor for changes to properties
class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    // inverse relationship with type and forward relationship defined in Category
    var parentContainer = LinkingObjects(fromType: Category.self, property: "items")
}

// each Item has an inverse relationship to Category - there is only one parent as each item belongs in a particular Category.
