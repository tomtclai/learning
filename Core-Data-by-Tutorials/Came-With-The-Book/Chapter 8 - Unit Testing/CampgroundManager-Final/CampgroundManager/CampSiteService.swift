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
    var campSite: CampSite = NSEntityDescription.insertNewObjectForEntityForName("CampSite", inManagedObjectContext: self.managedObjectContext) as! CampSite
        campSite.siteNumber = siteNumber
        campSite.electricity = NSNumber(bool: electricity)
        campSite.water = NSNumber(bool: water)
        
        self.coreDataStack.saveContext(self.managedObjectContext)
        
        return campSite
    }
    
    public func deleteCampSite(siteNumber: NSNumber) {
      if let campSite = self.getCampSite(siteNumber) {
        self.managedObjectContext.deleteObject(campSite)
        self.coreDataStack.saveContext(self.managedObjectContext)
      }
    }
  
  public func getCampSite(siteNumber: NSNumber) -> CampSite? {
    let fetchRequest = NSFetchRequest(entityName: "CampSite")
    fetchRequest.predicate = NSPredicate(format: "siteNumber == %@", argumentArray: [siteNumber])
    var error: NSError?
    let results = self.managedObjectContext.executeFetchRequest( fetchRequest, error: &error)
    
    if error != nil || results == nil {
      return nil
    }
    
    return results!.first as! CampSite?
  }


    
  public func getCampSites() -> Array<CampSite> {
    let fetchRequest = NSFetchRequest(entityName: "CampSite")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "siteNumber", ascending: true)]
    var error: NSError?
    let results = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! Array<CampSite>
    
    return results
  }
  
  public func getNextCampSiteNumber() -> NSNumber {
    let sites = self.getCampSites()
    
    if sites.count > 0 {
      let lastSiteNumber = sites.last!.siteNumber
      return lastSiteNumber.integerValue + 1
    }
    
    return 1
  }
}