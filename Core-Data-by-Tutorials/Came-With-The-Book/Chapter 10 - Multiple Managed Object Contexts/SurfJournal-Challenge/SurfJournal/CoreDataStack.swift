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

import CoreData

class CoreDataStack {
  
  let modelName = "SurfJournalModel"
  let seedName = "SurfJournalDatabase"
  
  lazy var applicationDocumentsDirectory: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(
      .DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1]
    }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = NSBundle.mainBundle()
      .URLForResource(self.modelName,
        withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
  
  lazy var psc: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(
      managedObjectModel: self.managedObjectModel)
    let url =
    self.applicationDocumentsDirectory
      .URLByAppendingPathComponent(self.seedName + ".sqlite")
    
    // 1
    let bundle = NSBundle.mainBundle()
    let seededDatabaseURL = bundle
      .URLForResource(self.seedName, withExtension: "sqlite")!

    // 2
    let didCopyDatabase: Bool
    do {
      try NSFileManager.defaultManager()
        .copyItemAtURL(seededDatabaseURL, toURL: url)
      didCopyDatabase = true
    } catch {
      didCopyDatabase = false
    }

    // 3
    if didCopyDatabase {
  
      // 4
      let seededSHMURL = bundle
        .URLForResource(self.seedName, withExtension: "sqlite-shm")!
      let shmURL = self.applicationDocumentsDirectory
        .URLByAppendingPathComponent(self.seedName + ".sqlite-shm")
      do {
        try NSFileManager.defaultManager()
          .copyItemAtURL(seededSHMURL, toURL: shmURL)
      } catch {
        let nserror = error as NSError
        print("Error: \(nserror.localizedDescription)")
        abort()
      }

      // 5
      let seededWALURL = bundle
        .URLForResource(self.seedName, withExtension: "sqlite-wal")!
      let walURL = self.applicationDocumentsDirectory
        .URLByAppendingPathComponent(self.seedName + ".sqlite-wal")
      do {
        try NSFileManager.defaultManager()
          .copyItemAtURL(seededWALURL, toURL: walURL)
      } catch {
        let nserror = error as NSError
        print("Error: \(nserror.localizedDescription)")
        abort()
      }
      
      print("Seeded Core Data")
    }
    
    // 6
    do {
      try coordinator.addPersistentStoreWithType(
        NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
    } catch {
      //7
        let nserror = error as NSError
        print("Error: \(nserror.localizedDescription)")
        abort()
    }
    
    return coordinator
    }()
  
  lazy var context: NSManagedObjectContext = {
    var managedObjectContext = NSManagedObjectContext(
      concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = self.psc
    return managedObjectContext
    }()
  
  func saveContext () {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        print("Error: \(nserror.localizedDescription)")
        abort()
      }
    }
  }
}

