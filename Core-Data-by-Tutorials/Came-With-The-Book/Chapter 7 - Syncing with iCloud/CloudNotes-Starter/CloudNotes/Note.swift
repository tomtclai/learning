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
    if let attachment = self.latestAttachment(), let image = attachment.image {
      return image
    }
    return nil
  }

  func latestAttachment() -> ImageAttachment? {
    if let attachmentsToSort = attachments.allObjects as? [ImageAttachment] {
      return attachmentsToSort
        .sorted {
          let date1 = $0.dateCreated.timeIntervalSinceReferenceDate
          let date2 = $1.dateCreated.timeIntervalSinceReferenceDate
          return date1 > date2
        }.first
    }
    return nil
  }

}