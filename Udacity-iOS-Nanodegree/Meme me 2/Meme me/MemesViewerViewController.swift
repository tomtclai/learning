//
//  MemesViewerViewController.swift
//  Meme me 2
//
//  Created by Tom Lai on 9/28/15.
//  Copyright © 2015 Lai. All rights reserved.
//

import UIKit

class MemesViewerViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image : UIImage?
    
    override func viewDidLoad() {
        imageView.contentMode = .ScaleAspectFit
    }
    
    override func viewWillAppear(animated: Bool) {
        if let image = image  {
            imageView.image = image
        }
    }
    

    
}
