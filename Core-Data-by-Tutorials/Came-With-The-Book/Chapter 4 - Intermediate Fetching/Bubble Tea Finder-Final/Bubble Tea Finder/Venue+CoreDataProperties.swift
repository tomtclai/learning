//
//  Venue+CoreDataProperties.swift
//  Bubble Tea Finder
//
//  Created by Pietro Rea on 7/30/15.
//  Copyright © 2015 Pietro Rea. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Venue {

    @NSManaged var favorite: NSNumber?
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var specialCount: NSNumber?
    @NSManaged var category: Category?
    @NSManaged var location: Location?
    @NSManaged var priceInfo: PriceInfo?
    @NSManaged var stats: Stats?

}
