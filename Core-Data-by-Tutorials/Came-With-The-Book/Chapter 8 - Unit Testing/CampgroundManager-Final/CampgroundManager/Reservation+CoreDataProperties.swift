//
//  Reservation+CoreDataProperties.swift
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

public extension Reservation {
  
  @NSManaged var dateFrom: NSDate?
  @NSManaged var dateTo: NSDate?
  @NSManaged var status: String?
  @NSManaged var camper: Camper?
  @NSManaged var campSite: CampSite?
  
}
