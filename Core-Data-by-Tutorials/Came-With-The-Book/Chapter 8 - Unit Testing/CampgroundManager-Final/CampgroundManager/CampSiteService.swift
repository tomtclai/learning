//
//  CampSiteService.swift
//  CampgroundManager
//
//  Created by Aaron Douglas on 8/18/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import Foundation
import CoreData

public class CampSiteService {
  let managedObjectContext: NSManagedObjectContext
  let coreDataStack: CoreDataStack
  
  public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
    self.managedObjectContext = managedObjectContext
    self.coreDataStack = coreDataStack
  }
  
  public func addCampSite(siteNumber: NSNumber, electricity: Bool, water: Bool) -> CampSite {
    let campSite = NSEntityDescription.insertNewObjectForEntityForName("CampSite", inManagedObjectContext: managedObjectContext) as! CampSite
    campSite.siteNumber = siteNumber
    campSite.electricity = NSNumber(bool: electricity)
    campSite.water = NSNumber(bool: water)
    
    coreDataStack.saveContext(managedObjectContext)
    
    return campSite
  }
  
  public func deleteCampSite(siteNumber: NSNumber) {
    if let campSite = getCampSite(siteNumber) {
      managedObjectContext.deleteObject(campSite)
      coreDataStack.saveContext(managedObjectContext)
    }
  }
  
  public func getCampSite(siteNumber: NSNumber) -> CampSite? {
    let fetchRequest = NSFetchRequest(entityName: "CampSite")
    fetchRequest.predicate = NSPredicate(format: "siteNumber == %@", argumentArray: [siteNumber])
    let results: [AnyObject]?
    do {
      results = try managedObjectContext.executeFetchRequest( fetchRequest)
    } catch {
      return nil
    }
    
    return results!.first as! CampSite?
  }
  
  
  
  public func getCampSites() -> Array<CampSite> {
    let fetchRequest = NSFetchRequest(entityName: "CampSite")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "siteNumber", ascending: true)]
    
    var results: Array<CampSite>
    do {
      try results = managedObjectContext.executeFetchRequest(fetchRequest) as! Array<CampSite>
    } catch {
      results = Array<CampSite>()
    }
    
    return results
  }
  
  public func getNextCampSiteNumber() -> NSNumber {
    let sites = getCampSites()
    
    if sites.count > 0 {
      let lastSiteNumber = sites.last!.siteNumber!
      return lastSiteNumber.integerValue + 1
    }
    
    return 1
  }
}