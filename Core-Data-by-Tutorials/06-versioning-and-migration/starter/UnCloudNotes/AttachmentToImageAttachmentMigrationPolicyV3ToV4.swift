//
//  AttachmentToImageAttachmentMigrationPolicyV3ToV4.swift
//  UnCloudNotes
//
//  Created by Tom Lai on 3/21/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreData
import UIKit

private let errorDomain = "AttachmentToImageAttachmentMigrationPolicyV3toV4"

class AttachmentToImageAttachmentMigrationPolicyV3toV4: NSEntityMigrationPolicy {

  // This method is an override of the default NSEntityMigrationPolicy implementation. It's what the migration manager uses to create instances of destination entities. An instance of the source object is the first parameter; when overriden, it's up to the developer to creat the desintation instance and associate it properly to the migration manager.
  override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
    // First you create an instance of the new destination object. The migration manager has two core data stacks. One to read from the source and one to write to the destination. So you need to be sure to use the destination context here. Now you might notice that this section isnt using the new fancy short imageAttachment(context: NSManagedObjectContext) initilizer. Well, as it turns out, this migration will simply crash using the new syntax, because it depends on the model having been loaded and finalied, which hasn't happened halfway through a migration.
    let description = NSEntityDescription.entity(forEntityName: "ImageAttachment", in: manager.destinationContext)
    let newAttachment = ImageAttachment(entity: description!, insertInto: manager.destinationContext)



    // Next, create a traversePropertyMappings fucntion that performs the task of iterating over the property mappings if they are present in the migration. This fucntion will control the traversal while the next section will perform the operation required for each property mapping.
    func traversePropertyMappings(block: (NSPropertyMapping, String) -> ()) throws {
      if let attributeMappings = mapping.attributeMappings {
        for propertyMapping in attributeMappings {
          if let destinationName = propertyMapping.name {
            block(propertyMapping, destinationName)
          } else {
            // If for some reaosn, the attributeMappings property on the entityMapping object deosn't return any mappings, this means your mappings file has been specified incorrectly. When this happens the method will throw an error with some helpful information.
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


    // Even tho it is a custom manual migration most of the attribute migrations should be performed using the expressions you defeind in the mapping model. To do this use the traversal function from the previous step and apply the value expression to the source instance and set the result to the new destination object
    try traversePropertyMappings(block: { (propertyMapping, destinationName) in
      if let valueExpression = propertyMapping.valueExpression {
        let context: NSMutableDictionary = ["source": sInstance]
        guard let destinationValue = valueExpression.expressionValue(with: sInstance, context: context) else {
          return
        }
        newAttachment.setValue(destinationValue, forKey: destinationName)
      }
    })

    // Next try to get an instance of the image. If it exists grab its width and height to populate the data in othe new object
    if let image = sInstance.value(forKey: "image") as? UIImage {
      newAttachment.setValue(image.size.width, forKey: "width")
      newAttachment.setValue(image.size.height, forKey: "height")
    }

    // For the caption simply grab the notes body text and take the first 80 characters
    let body = sInstance.value(forKeyPath: "note.body") as? NSString ?? ""
    if body.length > 80 {
      newAttachment.setValue(body.substring(to: 80), forKey: "caption")
    } else {
      newAttachment.setValue(body, forKey: "caption")
    }

    // The migration manager needs to know the connection between the source object, the newly created destination object and the mapping. Failing to call this method at the end of a custom migraion will result in missing data in the destination store.
    manager.associate(sourceInstance: sInstance, withDestinationInstance: newAttachment, for: mapping)
  }

}
