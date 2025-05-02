//
//  Meme.swift
//  Meme me
//
//  Created by Tom Lai on 9/25/15.
//  Copyright © 2015 Lai. All rights reserved.
//

import UIKit

struct Meme {

    var topText: String?
    var bottomText: String?
    var originalImage: UIImage?
    var memedImage: UIImage!

    init(topText: String?, bottomText: String?, originalImage: UIImage?, memedImage: UIImage?) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
