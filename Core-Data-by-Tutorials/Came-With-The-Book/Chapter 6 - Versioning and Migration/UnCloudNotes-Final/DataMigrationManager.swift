import Foundation
import CoreData

class DataMigrationManager {
  let storeName: String
  let modelName: String
  var options: NSDictionary?

  lazy var storeURL : NSURL = {
    var storePaths = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)
    let firstStorePath = String(storePaths.first) as NSString
        
    let storePath = firstStorePath.stringByAppendingPathComponent(
      self.storeName + ".sqlite") ?? ""
    
    return NSURL.fileURLWithPath(storePath)
  }()


  var storeModel : NSManagedObjectModel? {
    for model in NSManagedObjectModel
      .modelVersionsForName(self.modelName) {
        if self.storeIsCompatibleWith(Model:model) {
          print("Store \(self.storeURL) is compatible with model \(model.versionIdentifiers)")
          return model
        }
    }

    print("Unable to determine storeModel")
    return nil
  }


  lazy var currentModel: NSManagedObjectModel = {
    // Let core data tell us which model is the current model
    if let modelURL = NSBundle.mainBundle().URLForResource(
      self.modelName, withExtension:"momd") {
        return NSManagedObjectModel(contentsOfURL: modelURL) ?? NSManagedObjectModel()
    }
    return NSManagedObjectModel()
  }()

  var stack: CoreDataStack {
    if !storeIsCompatibleWith(Model: currentModel) {
      performMigration()
    }

    return CoreDataStack(modelName: modelName,
        storeName: storeName, options: options)
  }

  init(storeNamed: String, modelNamed: String) {
    self.storeName = storeNamed
    self.modelName = modelNamed
  }

  func performMigration() {
    if !currentModel.isVersion4() {
      fatalError("Can only handle migrations to version 4!")
    }

    if let storeModel = self.storeModel {
      if storeModel.isVersion1() {
        options =
          [NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true]
      } else {
        options =
          [NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: false]
      }

      if storeModel.isVersion1() {
        let destinationModel = NSManagedObjectModel.version2()

        migrateStoreAt(URL: storeURL,
          fromModel: storeModel,
          toModel: destinationModel)

        performMigration()
      } else if storeModel.isVersion2() {
        let destinationModel = NSManagedObjectModel.version3()
        let mappingModel = NSMappingModel(fromBundles: nil,
          forSourceModel: storeModel,
          destinationModel: destinationModel)

        migrateStoreAt(URL:storeURL,
          fromModel:storeModel,
          toModel:destinationModel,
          mappingModel: mappingModel)

        performMigration()
      } else if storeModel.isVersion3() {
        let destinationModel = NSManagedObjectModel.version4()
        let mappingModel = NSMappingModel(fromBundles: nil,
          forSourceModel: storeModel,
          destinationModel: destinationModel)
        
        migrateStoreAt(URL:storeURL,
          fromModel:storeModel,
          toModel:destinationModel,
          mappingModel: mappingModel)
      }
    }

  }

  func migrateStoreAt(URL storeURL:NSURL,
    fromModel from:NSManagedObjectModel,
    toModel to:NSManagedObjectModel,
    mappingModel:NSMappingModel? = nil) {

    let migrationManager = NSMigrationManager(sourceModel:from, destinationModel:to)

    var migrationMappingModel : NSMappingModel
    if let mappingModel = mappingModel {
      migrationMappingModel = mappingModel
    } else {
      migrationMappingModel = try! NSMappingModel
        .inferredMappingModelForSourceModel(
        from, destinationModel: to)
    }

    let destinationURL = storeURL.URLByDeletingLastPathComponent
    let destinationName = (storeURL.lastPathComponent ?? "") + "~" + "1"
    let destination = destinationURL!.URLByAppendingPathComponent(destinationName)

    print("From Model: \(from.versionIdentifiers)")
    print("To Model: \(to.versionIdentifiers)")
    print("Migrating store \(storeURL) to \(destination)")
    print("Mapping model: \(mappingModel)")

    let success: Bool
    do {
      try migrationManager.migrateStoreFromURL(storeURL,
            type:NSSQLiteStoreType,
            options:nil,
            withMappingModel:migrationMappingModel,
            toDestinationURL:destination,
            destinationType:NSSQLiteStoreType,
            destinationOptions:nil)
      success = true
    } catch let error as NSError {
      success = false
      NSLog("Migration failed: \(error)")
    }

    if success {
      print("Migration Completed Successfully")

      let fileManager = NSFileManager.defaultManager()
      do {
        try fileManager.removeItemAtURL(storeURL)
        try fileManager.moveItemAtURL(destination, toURL: storeURL)
      } catch let error as NSError {
        NSLog("Error migrating \(error)")
      }
    }
  }

  func storeIsCompatibleWith(Model model:NSManagedObjectModel)
   -> Bool {
    let storeMetadata = metadataForStoreAtURL(storeURL)

    return model.isConfiguration(nil,
      compatibleWithStoreMetadata:storeMetadata)
  }

  func metadataForStoreAtURL(storeURL:NSURL) -> [String: AnyObject] {
    let metadata: [String: AnyObject]?
    do {
      metadata = try NSPersistentStoreCoordinator.metadataForPersistentStoreOfType(
            NSSQLiteStoreType, URL: storeURL)
    } catch let error as NSError {
      metadata = nil
      print("Error retrieving metadata for store at URL: \(storeURL): \(error)")
    }
    return metadata ?? [:]
  }

}

extension NSManagedObjectModel {
  class func modelVersionsForName(name: String)
   -> [NSManagedObjectModel] {
    let urls = NSBundle.mainBundle()
      .URLsForResourcesWithExtension("mom",
        subdirectory:"\(name).momd") ?? []

    return urls.map { NSManagedObjectModel(contentsOfURL:$0) }
      .filter { $0 != nil }
      .map { $0! }
  }

  class func uncloudNotesModelNamed(name:String) -> NSManagedObjectModel {
    if let modelURL = NSBundle.mainBundle().URLForResource(name, withExtension:"mom", subdirectory:"UnCloudNotesDataModel.momd") {
      return NSManagedObjectModel(contentsOfURL:modelURL) ?? NSManagedObjectModel()
    }
    return NSManagedObjectModel()
  }

  class func version1() -> NSManagedObjectModel {
    return uncloudNotesModelNamed("UnCloudNotesDataModel")
  }
  func isVersion1() -> Bool {
    return self == self.dynamicType.version1()
  }
  class func version2() -> NSManagedObjectModel {
    return uncloudNotesModelNamed("UnCloudNotesDataModel v2")
  }
  func isVersion2() -> Bool {
    return self == self.dynamicType.version2()
  }
  class func version3() -> NSManagedObjectModel {
    return uncloudNotesModelNamed("UnCloudNotesDataModel v3")
  }
  func isVersion3() -> Bool {
    return self == self.dynamicType.version3()
  }
  class func version4() -> NSManagedObjectModel {
    return uncloudNotesModelNamed("UnCloudNotesDataModel v4")
  }
  func isVersion4() -> Bool {
    return self == self.dynamicType.version4()
  }
}

func ==(firstModel:NSManagedObjectModel, otherModel:NSManagedObjectModel) -> Bool {

  let myEntities = firstModel.entitiesByName
  let otherEntities = otherModel.entitiesByName

  return NSDictionary(dictionary: myEntities).isEqualToDictionary(otherEntities)
}
