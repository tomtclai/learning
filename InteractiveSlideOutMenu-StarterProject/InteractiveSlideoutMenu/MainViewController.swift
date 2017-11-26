//
//  MainViewController.swift
//  InteractiveSlideoutMenu
//
//  Created by Robert Chen on 2/7/16.
//  Copyright © 2016 Thorn Technologies, LLC. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBAction func openMenu(_ sender: AnyObject) {
        performSegue(withIdentifier: "openMenu", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

