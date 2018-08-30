//
//  Walk+CoreDataProperties.swift
//  Dog Walk
//
//  Created by Tom Lai on 2/4/18.
//  Copyright © 2018 Razeware. All rights reserved.
//
//

import Foundation
import CoreData

extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var dog: Dog?

}
