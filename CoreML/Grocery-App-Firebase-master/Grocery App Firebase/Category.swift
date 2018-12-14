//
//  Category.swift
//  Grocery App Firebase
//
//  Created by Hayden Goldman on 3/8/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import Foundation

class Category {
    
    var title :String!
    var items = [Item]()
    
    func toDictionary() -> [String:Any] {
        
        return ["title":self.title,"items":self.items.map {item in
            return item.toDictionary()
            }]
    }
}
