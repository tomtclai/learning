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
    return latestAttachment?.image
  }

  var latestAttachment: Attachment? {
    let attachmentsToSort = attachments.allObjects.map { $0 as? Attachment }
      .filter { $0 != nil }
      .map { $0! }.sort {
        let date1 = $0.dateCreated.timeIntervalSinceReferenceDate
        let date2 = $1.dateCreated.timeIntervalSinceReferenceDate
        return date1 > date2
    }
    
    return attachmentsToSort.first
  }

}