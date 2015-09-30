//
//  CampSite+CoreDataProperties.swift
//  CampgroundManager
//
//  Created by Aaron Douglas on 6/26/15.
//  Copyright © 2015 Razeware. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

public extension CampSite {
  
  @NSManaged var electricity: NSNumber?
  @NSManaged var siteNumber: NSNumber?
  @NSManaged var water: NSNumber?
  @NSManaged var reservations: Reservation?
  
}
