/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation
import CoreData

class DataMigrationManager {
  let storeName: String
  let modelName: String
  var options: NSDictionary?

  lazy var storeURL : NSURL = {
    var storePaths = NSSearchPathForDirectoriesInDomains(
        .ApplicationSupportDirectory, .UserDomainMask, true) as! [NSString]
    let storePath = storePaths.first as? String
    if let filePath = storePath?.stringByAppendingPathComponent(self.storeName + ".sqlite") {
        return NSURL(fileURLWithPath: filePath)!
    }
    return NSURL()
    
  }()


  var storeModel : NSManagedObjectModel? {
    for model in NSManagedObjectModel
      .modelVersionsForName(self.modelName) {
        if self.storeIsCompatibleWith(Model:model) {
          println("Store \(self.storeURL) is compatible with model \(model.versionIdentifiers)")
          return model
        }
    }

    println("Unable to determine storeModel")
    return nil
  }


  lazy var currentModel: NSManagedObjectModel = {
    // Let core data tell us which model is the current model
    let modelURL = NSBundle.mainBundle().URLForResource(
      self.modelName, withExtension:"momd")
    let model = NSManagedObjectModel(contentsOfURL: modelURL!)
    return model ?? NSManagedObjectModel()
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
      var error : NSError?
      migrationMappingModel = NSMappingModel
        .inferredMappingModelForSourceModel(
        from, destinationModel: to, error: &error)!
    }

    let destinationURL = storeURL.URLByDeletingLastPathComponent
    let destinationName = storeURL.lastPathComponent! + "~" + "1"
    let destination = destinationURL!.URLByAppendingPathComponent(destinationName)

    println("From Model: \(from.versionIdentifiers)")
    println("To Model: \(to.versionIdentifiers)")
    println("Migrating store \(storeURL) to \(destination)")
    println("Mapping model: \(mappingModel)")

    var error : NSError?
    let success =
    migrationManager.migrateStoreFromURL(storeURL,
      type:NSSQLiteStoreType,
      options:nil,
      withMappingModel:mappingModel,
      toDestinationURL:destination,
      destinationType:NSSQLiteStoreType,
      destinationOptions:nil,
      error:&error)

    if success {
      println("Migration Completed Successfully")

      var error : NSError?
      let fileManager = NSFileManager.defaultManager()
      fileManager.removeItemAtURL(storeURL, error: &error)
      fileManager.moveItemAtURL(destination, toURL: storeURL, error:&error)
    } else {
      println("Error migrating \(error)")
    }
  }

  func storeIsCompatibleWith(Model model:NSManagedObjectModel)
   -> Bool {
    let storeMetadata = metadataForStoreAtURL(storeURL)

    return model.isConfiguration(nil,
      compatibleWithStoreMetadata:storeMetadata)
  }

  func metadataForStoreAtURL(storeURL:NSURL) -> [NSObject: AnyObject] {
    var error : NSError?
    let metadata = NSPersistentStoreCoordinator.metadataForPersistentStoreOfType(
        NSSQLiteStoreType, URL: storeURL, error: &error)
    if metadata == nil {
        println(error)
    }
    return metadata ?? [:]
  }

}

extension NSManagedObjectModel {
  class func modelVersionsForName(name: String)
   -> [NSManagedObjectModel] {
    let urls = NSBundle.mainBundle()
      .URLsForResourcesWithExtension("mom",
        subdirectory:"\(name).momd") as! [NSURL]
    return urls
        .map { NSManagedObjectModel(contentsOfURL:$0) }
        .filter { $0 != nil }
        .map { $0! }
  }

  class func cloudNotesModelNamed(name:String) -> NSManagedObjectModel {
    if let modelURL = NSBundle.mainBundle().URLForResource(name, withExtension:"mom", subdirectory:"CloudNotesDataModel.momd") {
      return NSManagedObjectModel(contentsOfURL:modelURL) ?? NSManagedObjectModel()
    }
    return  NSManagedObjectModel()
  }

  class func version1() -> NSManagedObjectModel {
    return cloudNotesModelNamed("CloudNotesDataModel")
  }
  func isVersion1() -> Bool {
    return self == self.dynamicType.version1()
  }
  class func version2() -> NSManagedObjectModel {
    return cloudNotesModelNamed("CloudNotesDataModel v2")
  }
  func isVersion2() -> Bool {
    return self == self.dynamicType.version2()
  }
  class func version3() -> NSManagedObjectModel {
    return cloudNotesModelNamed("CloudNotesDataModel v3")
  }
  func isVersion3() -> Bool {
    return self == self.dynamicType.version3()
  }
  class func version4() -> NSManagedObjectModel {
    return cloudNotesModelNamed("CloudNotesDataModel v4")
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
