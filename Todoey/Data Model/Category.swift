//
//  Category.swift
//  Todoey
//
//  Created by John Ure on 23/01/2018.
//  Copyright © 2018 Soft Touch. All rights reserved.
//

import Foundation
import RealmSwift

// class for Realm Object, needs Obj-C and dynamic so Realm can monitor for changes to properties
class Category: Object {
    @objc dynamic var name: String = ""
    // for Chameleon, save initial random color
    @objc dynamic var colour: String = ""
    // forward relationship using Realm List array with data type, init as empty
    let items = List<Item>()
}

// each Category has a one-to-many relationship with Item cos there are many items in the Category.
