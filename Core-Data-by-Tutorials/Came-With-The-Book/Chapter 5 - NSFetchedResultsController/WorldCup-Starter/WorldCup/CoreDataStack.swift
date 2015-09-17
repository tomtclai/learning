//
//  CoreDataStack.swift
//  WorldCup
//
//  Created by Pietro Rea on 8/2/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  
  var context:NSManagedObjectContext
  var psc:NSPersistentStoreCoordinator
  var model:NSManagedObjectModel
  var store:NSPersistentStore?
  
  init() {
    
    let bundle = NSBundle.mainBundle()
    let modelURL =
    bundle.URLForResource("WorldCup", withExtension:"momd")
    model = NSManagedObjectModel(contentsOfURL: modelURL!)!
    
    psc = NSPersistentStoreCoordinator(managedObjectModel:model)
    
    context = NSManagedObjectContext()
    context.persistentStoreCoordinator = psc
    
    let documentsURL = applicationDocumentsDirectory()
    let storeURL =
    documentsURL.URLByAppendingPathComponent("WorldCup")
    
    let options =
    [NSMigratePersistentStoresAutomaticallyOption: true]
    
    var error: NSError? = nil
    store = psc.addPersistentStoreWithType(NSSQLiteStoreType,
      configuration: nil,
      URL: storeURL,
      options: options,
      error:&error)
    
    if store == nil {
      println("Error adding persistent store: \(error)")
      abort()
    }
    
  }
  
  func saveContext() {
    
    var error: NSError? = nil
    if context.hasChanges && !context.save(&error) {
      println("Could not save: \(error), \(error?.userInfo)")
    }
    
  }
  
  func applicationDocumentsDirectory() -> NSURL {
    
    let fileManager = NSFileManager.defaultManager()
    
    let urls = fileManager.URLsForDirectory(.DocumentDirectory,
      inDomains: .UserDomainMask) as! Array<NSURL>
    
    return urls[0]
  }
  
}