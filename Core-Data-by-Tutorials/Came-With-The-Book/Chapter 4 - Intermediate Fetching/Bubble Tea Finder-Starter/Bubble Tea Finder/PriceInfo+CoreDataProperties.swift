//
//  PriceInfo+CoreDataProperties.swift
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

extension PriceInfo {

    @NSManaged var priceCategory: String?
    @NSManaged var venue: Venue?

}
