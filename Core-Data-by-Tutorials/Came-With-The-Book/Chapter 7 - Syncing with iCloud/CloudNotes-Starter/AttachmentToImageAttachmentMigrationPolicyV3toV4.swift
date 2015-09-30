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
