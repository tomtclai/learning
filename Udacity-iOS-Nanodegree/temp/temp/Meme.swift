//
//  Meme.swift
//  temp
//
//  Created by Tom Lai on 9/25/15.
//  Copyright © 2015 Your Company. All rights reserved.
//

import UIKit

class Meme: NSObject {

    var topText : String?
    var bottomText : String?
    var originalImage : UIImage?
    var memedImage : UIImage!
    
    
    init(topText:String?, bottomText:String?, originalImage:UIImage?, memedImage:UIImage?) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
        super.init()
    }
    
    override convenience init() {
        self.init(topText: nil, bottomText: nil, originalImage: nil, memedImage: nil)
    }
}
