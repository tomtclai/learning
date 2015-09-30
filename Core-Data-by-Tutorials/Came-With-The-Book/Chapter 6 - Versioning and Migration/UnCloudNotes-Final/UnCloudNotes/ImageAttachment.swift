import UIKit
import CoreData

class ImageAttachment: Attachment {
  @NSManaged var image: UIImage?
  @NSManaged var width: CGFloat
  @NSManaged var height: CGFloat
  @NSManaged var caption: NSString
}
