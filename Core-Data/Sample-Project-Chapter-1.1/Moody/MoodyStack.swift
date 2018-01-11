//
//  MoodyStack.swift
//  Moody
//
//  Created by Florian on 18/08/15.
//  Copyright © 2015 objc.io. All rights reserved.
//

import CoreData


func createMoodyContainer(completion: @escaping (NSPersistentContainer) -> ()) {
  let container = NSPersistentContainer(name: "Moody")
  container.loadPersistentStores { _, error in
    guard error == nil else {
      // in production, you might want to react differently:
      // - migrate an existing store
      // - delete and recreate the store
      fatalError("Failed to load store: \(error!)")
    }
    DispatchQueue.main.async {
      completion(container)
    }
  }
}
