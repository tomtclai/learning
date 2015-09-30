import CampgroundManager
import Foundation
import CoreData

class TestCoreDataStack: CoreDataStack {
  override init() {
    super.init()
    self.persistentStoreCoordinator = {
      let psc = NSPersistentStoreCoordinator(
        managedObjectModel: self.managedObjectModel)
      
      do {
        try psc.addPersistentStoreWithType(
          NSInMemoryStoreType, configuration: nil,
          URL: nil, options: nil)
      } catch {
        fatalError()
      }
      
      return psc
      }()
  }
}
