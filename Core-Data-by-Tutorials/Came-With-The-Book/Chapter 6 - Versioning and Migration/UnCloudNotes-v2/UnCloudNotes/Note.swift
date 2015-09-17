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

class Note : NSManagedObject
{
    @NSManaged var title : NSString!
    @NSManaged var body : NSString!
    @NSManaged var dateCreated: NSDate!
    @NSManaged var displayIndex: NSNumber!
    @NSManaged var image: UIImage?

    override func awakeFromInsert()
    {
        super.awakeFromInsert()
        dateCreated = NSDate()
    }
}