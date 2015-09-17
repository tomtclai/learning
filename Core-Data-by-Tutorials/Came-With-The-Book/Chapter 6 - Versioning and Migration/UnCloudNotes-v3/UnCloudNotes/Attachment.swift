import Foundation
import UIKit
import CoreData

class Attachment: NSManagedObject {
  @NSManaged var dateCreated: NSDate
  @NSManaged var image: UIImage?
  @NSManaged var note: Note
}
