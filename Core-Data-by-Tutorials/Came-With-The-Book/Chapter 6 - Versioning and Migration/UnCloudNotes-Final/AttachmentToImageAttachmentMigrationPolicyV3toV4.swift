import CoreData
import UIKit

class AttachmentToImageAttachmentMigrationPolicyV3toV4: NSEntityMigrationPolicy {
  override func createDestinationInstancesForSourceInstance(
    sInstance: NSManagedObject,
    entityMapping mapping: NSEntityMapping,
    manager: NSMigrationManager, error: NSErrorPointer) -> Bool {
      // 1
      if let newAttachment = NSEntityDescription.insertNewObjectForEntityForName(
        "ImageAttachment",
        inManagedObjectContext: manager.destinationContext) as? NSManagedObject {

          // 2
          for propertyMapping in mapping.attributeMappings
            as! [NSPropertyMapping] {
              let destinationName = propertyMapping.name
              if let valueExpression = propertyMapping.valueExpression {
                let context: NSMutableDictionary = ["source": sInstance]
                let destinationValue: AnyObject =
                valueExpression.expressionValueWithObject(sInstance,
                  context: context)
                newAttachment.setValue(destinationValue,
                  forKey: destinationName!)
              }
          }

          // 3
          if let image = sInstance.valueForKey("image") as? UIImage {
            newAttachment.setValue(image.size.width, forKey: "width")
            newAttachment.setValue(image.size.height, forKey: "height")
          }

          // 4
          let body = sInstance.valueForKeyPath("note.body") as? NSString ?? ""
          newAttachment.setValue(body.substringToIndex(80),
            forKey: "caption")
          
          // 5
          manager.associateSourceInstance(sInstance,
            withDestinationInstance: newAttachment,
            forEntityMapping: mapping)
            
          // 6
          return true
      }
      return false
  }


}
