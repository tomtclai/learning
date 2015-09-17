//
//  CoreDataStack.swift
//  UnCloudNotes
//
//  Created by Saul Mora on 6/17/14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: Printable {
  var modelName : String
  var storeName : String

  init(modelName:String, storeName:String) {
    self.modelName = modelName
    self.storeName = storeName
  }

  var description : String
    {
    return "context: \(context)\n" +
      "modelName: \(modelName)" +
      //        "model: \(model.entityVersionHashesByName)\n" +
      //        "coordinator: \(coordinator)\n" +
      "storeURL: \(storeURL)\n"
      //        "store: \(store)"
  }

  var modelURL : NSURL {
    return NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
  }

  var storeURL : NSURL {
    var storePaths = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true) as! [NSString]
    let storePath = String(storePaths[0])
    let fileManager = NSFileManager.defaultManager()

    fileManager.createDirectoryAtPath(storePath, withIntermediateDirectories: true, attributes: nil, error: nil)
    return NSURL(fileURLWithPath: storePath.stringByAppendingPathComponent(storeName + ".sqlite"))!
  }

  lazy var model : NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: self.modelURL)!

  var store : NSPersistentStore?

  lazy var coordinator : NSPersistentStoreCoordinator = {
      let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
      var storeError : NSError?
      self.store = coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil,
        URL: self.storeURL,
        options: nil,
        error: &storeError)
      if storeError != nil {
        println("store error \(storeError!)")
      }
    return coordinator
  }()

  lazy var context : NSManagedObjectContext = {
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.persistentStoreCoordinator = self.coordinator
    println(self)
    return context
  }()
}
