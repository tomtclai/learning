//
//  CoreDataStack.swift
//  Dog Walk
//
//  Created by Tom Lai on 2/4/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  private let modelName: String
  init(modelName: String) {
    self.modelName = modelName
  }

  // On a day-to-day basis, you'll work with NSManagedObjectContext the most out of the four stack components. You'll probably only see the other three components when you need to do something more advanced with Core Data
  lazy var managedContext: NSManagedObjectContext = {
    return self.storeContainer.viewContext
  }()

  // As of iOS 10, there is a new class to orchestrate all four Core Data stack classes:
  // - the managed model
  // - the store Coordinator
  // - the persistent store
  // - the managed context
  private lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        print("Unresolved error \(error) \(error.userInfo)")
      }
    }
    return container
  }()

  func saveContext() {
    guard managedContext.hasChanges else { return }
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error) \(error.userInfo)")
    }
  }
}
