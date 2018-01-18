//
//  Item.swift
//  Todoey
//
//  Created by John Ure on 15/01/2018.
//  Copyright © 2018 Soft Touch. All rights reserved.
//

import Foundation

// class conforms to both Encodable and Decodable protocols
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
