//
//  DataMigrationManager.swift
//  UnCloudNotes
//
//  Created by Tom Lai on 3/24/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreData
class DataMigrationManager {
  let enableMigrations: Bool
  let modelName: String
  let storeName: String = "UnCloudNotesDataModel"
  var stack: CoreDataStack

  init(modelName: String, enabledMigrations: Bool = false) {
    self.modelName = modelNamed
    self.eneabledMigrations = enableMigrations 
  }
}
