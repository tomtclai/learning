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
    @NSManaged var thumbnailUrl: String?
    @NSManaged var pin: VTAnnotation?
    
    struct Keys {
        static let ImageUrl = "imageUrl"
        static let ThumbnailUrl = "thumbnailUrl"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Image", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        imageUrl = dictionary[Keys.ImageUrl] as? String
        thumbnailUrl = dictionary[Keys.ThumbnailUrl] as? String
    }
    
}
