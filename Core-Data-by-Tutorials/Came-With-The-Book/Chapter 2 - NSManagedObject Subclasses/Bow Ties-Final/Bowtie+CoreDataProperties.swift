//
//  Bowtie+CoreDataProperties.swift
//  Bow Ties
//
//  Created by Pietro Rea on 7/13/15.
//  Copyright © 2015 Razeware. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Bowtie {

    @NSManaged var name: String?
    @NSManaged var isFavorite: NSNumber?
    @NSManaged var lastWorn: NSDate?
    @NSManaged var rating: NSNumber?
    @NSManaged var searchKey: String?
    @NSManaged var timesWorn: NSNumber?
    @NSManaged var photoData: NSData?
    @NSManaged var tintColor: NSObject?

}
