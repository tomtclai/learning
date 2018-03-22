//
//  ImageAttachment.swift
//  UnCloudNotes
//
//  Created by Tom Lai on 3/21/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ImageAttachment: NSManagedObject {
  @NSManaged var image: UIImage?
  @NSManaged var width: Float
  @NSManaged var height: Float
  @NSManaged var caption: String
}

