//
//  ImageAttachment.swift
//  UnCloudNotes
//
//  Created by Tom Lai on 3/28/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit
import CoreData

class ImageAttachment: Attachment {
  @NSManaged var image: UIImage?
  @NSManaged var width: Float
  @NSManaged var height: Float
  @NSManaged var caption: String
}
