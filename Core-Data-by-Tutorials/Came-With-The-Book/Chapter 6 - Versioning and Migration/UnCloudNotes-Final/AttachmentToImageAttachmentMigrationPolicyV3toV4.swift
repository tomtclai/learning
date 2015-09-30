import CoreData
import UIKit

let errorDomain = "Migration"

class AttachmentToImageAttachmentMigrationPolicyV3toV4: NSEntityMigrationPolicy {
  override func createDestinationInstancesForSourceInstance(
    sInstance: NSManagedObject,
    entityMapping mapping: NSEntityMapping,
    manager: NSMigrationManager) throws {

    // 1
    let newAttachment = NSEntityDescription.insertNewObjectForEntityForName(
      "ImageAttachment",
      inManagedObjectContext: manager.destinationContext)

    // 2
    func traversePropertyMappings(block: (NSPropertyMapping, String) -> ()) throws {
      if let attributeMappings = mapping.attributeMappings {
        for propertyMapping in attributeMappings {
          if let destinationName = propertyMapping.name {
            block(propertyMapping, destinationName)
          } else {
    // 3
            let message = "Attribute destination not configured properly"
            let userInfo = [NSLocalizedFailureReasonErrorKey: message]
            throw NSError(domain: errorDomain, code: 0, userInfo: userInfo)
          }
        }
      } else {
        let message = "No Attribute Mappings found!"
        let userInfo = [NSLocalizedFailureReasonErrorKey: message]
        throw NSError(domain: errorDomain, code: 0, userInfo: userInfo)
      }
    }
      
    // 4
    try traversePropertyMappings { propertyMapping, destinationName in
      if let valueExpression = propertyMapping.valueExpression {
        let context: NSMutableDictionary = ["source": sInstance]
        let destinationValue: AnyObject =
        valueExpression.expressionValueWithObject(sInstance,
          context: context)
        newAttachment.setValue(destinationValue,
          forKey: destinationName)
      }
    }

    // 5
    if let image = sInstance.valueForKey("image") as? UIImage {
      newAttachment.setValue(image.size.width, forKey: "width")
      newAttachment.setValue(image.size.height, forKey: "height")
    }

    // 6
    let body = sInstance.valueForKeyPath("note.body") as? NSString ?? ""
    newAttachment.setValue(body.substringToIndex(80),
      forKey: "caption")
    
    // 7
    manager.associateSourceInstance(sInstance,
      withDestinationInstance: newAttachment,
      forEntityMapping: mapping)
  }

}
