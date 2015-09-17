//
//  RWTImageTransformer.swift
//  UnCloudNotes
//
//  Created by Richard Turton on 25/07/2014.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit

class ImageTransformer : NSValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return  true
    }
    
    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        if (value == nil) {
            return nil
        }
        
        return UIImage(data: value as! NSData)
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        return UIImagePNGRepresentation(value as? UIImage)
    }
        
}
