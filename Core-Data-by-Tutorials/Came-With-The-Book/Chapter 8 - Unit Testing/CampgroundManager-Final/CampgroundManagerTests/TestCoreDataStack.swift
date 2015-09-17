import CampgroundManager
import Foundation
import CoreData

class TestCoreDataStack: CoreDataStack {
  override init() {
    super.init()
    self.persistentStoreCoordinator = {
      var psc: NSPersistentStoreCoordinator? =
      NSPersistentStoreCoordinator(managedObjectModel:
        self.managedObjectModel)
      var error: NSError? = nil
      
      var ps = psc!.addPersistentStoreWithType(
        NSInMemoryStoreType, configuration: nil,
        URL: nil, options: nil, error: &error)
      
      if (ps == nil) {
        abort()
      }
      
      return psc
      }()
    
  }
}
