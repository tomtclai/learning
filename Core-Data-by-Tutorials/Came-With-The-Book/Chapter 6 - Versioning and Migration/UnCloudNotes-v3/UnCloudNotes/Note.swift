//
//  Note.swift
//  UnCloudNotes
//
//  Created by Saul Mora on 6/16/14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Note : NSManagedObject {
  @NSManaged var title : NSString
  @NSManaged var body : NSString
  @NSManaged var dateCreated: NSDate
  @NSManaged var displayIndex: NSNumber
  @NSManaged var attachments: NSSet

  override func awakeFromInsert()
  {
    super.awakeFromInsert()
    dateCreated = NSDate()
  }

  var image: UIImage? {
    if let attachment = self.latestAttachment() {
      if attachment.image != nil {
        return attachment.image
      }
      }
      return nil
  }

  func latestAttachment() -> Attachment? {
    let attachmentsToSort = attachments.allObjects as? [Attachment]
    if attachmentsToSort?.count == 0 {
      return nil
    }

    attachmentsToSort?.sorted {
      let date1 = $0.dateCreated.timeIntervalSinceReferenceDate
      let date2 = $1.dateCreated.timeIntervalSinceReferenceDate
      return date1 > date2
    }

    return attachmentsToSort?[0]
  }

}