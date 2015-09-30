//
//  CamperService.swift
//  CampgroundManager
//
//  Created by Aaron Douglas on 8/24/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import Foundation
import CoreData

public class CamperService {
  let managedObjectContext: NSManagedObjectContext
  let coreDataStack: CoreDataStack
  
  public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
    self.managedObjectContext = managedObjectContext
    self.coreDataStack = coreDataStack
  }
  
  public func addCamper(name: String, phoneNumber: String) -> Camper? {
    let camper = NSEntityDescription.insertNewObjectForEntityForName("Camper", inManagedObjectContext: managedObjectContext) as! Camper
    camper.fullName = name
    camper.phoneNumber = phoneNumber
    
    coreDataStack.saveContext(managedObjectContext)
    
    return camper
  }
}