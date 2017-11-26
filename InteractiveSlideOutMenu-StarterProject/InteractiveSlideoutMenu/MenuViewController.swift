//
//  MenuViewController.swift
//  InteractiveSlideoutMenu
//
//  Created by Robert Chen on 2/7/16.
//  Copyright © 2016 Thorn Technologies, LLC. All rights reserved.
//

import UIKit

class MenuViewController : UIViewController {
    
    @IBAction func closeMenu(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
