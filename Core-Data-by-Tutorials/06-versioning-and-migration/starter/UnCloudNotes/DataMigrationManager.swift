//
//  DataMigrationManager.swift
//  UnCloudNotes
//
//  Created by Tom Lai on 3/29/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreData

class DataMigrationManager {
  let enableMigration: Bool
  let modelName: String
  let storeName: String = "UnCloudNotesDataModel"
  private lazy var currentModel: NSManagedObjectModel = .model(named: self.modelName)
  var stack: CoreDataStack {
    guard enableMigration, !store(at: storeURL, isCompatibleWithModel: currentModel) else {
      return CoreDataStack(modelName: modelName)
    }
    performMigration()
    return CoreDataStack(modelName: modelName)
  }

  init(modelNamed: String, enableMigrations: Bool = false) {
    self.modelName = modelNamed
    self.enableMigration = enableMigrations
  }

  // Simple convenience wrapper to determin whether the persistent store is compatible with a given model.
  private func store(at storeURL: URL, isCompatibleWithModel model: NSManagedObjectModel) -> Bool {
    let storeMetadata = metadataForStoreAtURL(storeURL: storeURL)
    return model.isConfiguration(withName: nil, compatibleWithStoreMetadata: storeMetadata)
  }

  // Safely retreive the metadata for the store.
  private func metadataForStoreAtURL(storeURL: URL) -> [String: Any] {
    let metadata: [String: Any]
    do {
      metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: storeURL, options: nil)
    } catch {
      metadata = [:]
      print("Error retrieving metadata for store at URL: \(storeURL) : \(error)")
    }
    return metadata
  }

  private var applicationSupportURL: URL {
    let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first
    return URL(fileURLWithPath: path!)
  }

  private lazy var storeURL: URL = {
    let storeFileName = "\(storeName).sqlite"
    return URL(fileURLWithPath: storeFileName, relativeTo: applicationSupportURL)
  }()

  private var storeModel: NSManagedObjectModel? {
    return NSManagedObjectModel.modelVersionFor(modelNamed: modelName)
      .filter {
        self.store(at: storeURL, isCompatibleWithModel: $0)
    }.first
  }

  func performMigration() {

  }

}

extension NSManagedObjectModel {
  private class func modelURLs(in modelFolder: String) -> [URL] {
    return Bundle.main.urls(forResourcesWithExtension: "mom", subdirectory: "\(modelFolder).momd") ?? []
  }

  // Returns all model versions for a given name
  class func modelVersionFor(modelNamed modelName: String) -> [NSManagedObjectModel] {
    return modelURLs(in: modelName).flatMap(NSManagedObjectModel.init)
  }

  // Returns a specific instance of NSManagedObjectModel named UnCloudNotesDataModel
  class func uncloudNotesModel(named modelName: String) -> NSManagedObjectModel {
    let model = modelURLs(in: "UnCloudNotesDataModel")
      .filter { $0.lastPathComponent == "\(modelName).mom" }
      .first
      .flatMap(NSManagedObjectModel.init)
    return model ?? NSManagedObjectModel()
  }

  private class func unCloudNotesFileName(version: Int) -> String {
    return "UnCloudNotesDataModel v\(version)"

  }

  class var version2: NSManagedObjectModel {
    return uncloudNotesModel(named: unCloudNotesFileName(version: 2))
  }

  var isVersion2: Bool {
    return self == type(of: self).version2
  }

  class var version3: NSManagedObjectModel {
    return uncloudNotesModel(named: unCloudNotesFileName(version: 3))
  }

  var isVersion3: Bool {
    return self == type(of: self).version3
  }

  class var version4: NSManagedObjectModel {
    return uncloudNotesModel(named: unCloudNotesFileName(version: 4))
  }

  var isVersion4: Bool {
    return self == type(of: self).version4
  }

  class func model(named modelName: String, in bundle: Bundle = .main) -> NSManagedObjectModel {
    return bundle.url(forResource: modelName, withExtension: "momd")
    .flatMap(NSManagedObjectModel.init) ?? NSManagedObjectModel()
  }
}

func == (firstModel: NSManagedObjectModel, otherModel: NSManagedObjectModel) -> Bool {
  return firstModel.entitiesByName == otherModel.entitiesByName
}
