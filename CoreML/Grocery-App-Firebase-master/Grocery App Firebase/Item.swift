//
//  Item.swift
//  Grocery App Firebase
//
//  Created by Hayden Goldman on 3/8/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import Foundation

class Item {
    
    var title :String!
    
    func toDictionary() -> [String:Any] {
        return ["title":self.title]
    }
}
