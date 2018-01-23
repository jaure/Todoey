//
//  Data.swift
//  Todoey
//
//  Created by John Ure on 23/01/2018.
//  Copyright © 2018 Soft Touch. All rights reserved.
//

import Foundation
import RealmSwift

// class to define Realm model objects
class Data: Object {
    // dynamic means property can be monitored for change by Realm while app running - from Obj-C
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
