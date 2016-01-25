//
//  Image.swift
//  Virtual Tourist
//
//  Created by Tom Lai on 1/24/16.
//  Copyright © 2016 Lai. All rights reserved.
//

import Foundation
import CoreData


class Image: NSManagedObject {
    @NSManaged var imageUrl: String?
    @NSManaged var pin: VTAnnotation?
    
    struct Keys {
        static let ImageURL = "imageUrl"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Image", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        imageUrl = dictionary[Keys.ImageURL] as? String
    }
}
