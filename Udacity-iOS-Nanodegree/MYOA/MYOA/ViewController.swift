//
//  ViewController.swift
//  MYOA
//
//  Created by Tom Lai on 9/26/15.
//  Copyright © 2015 Lai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let img = UIImage(named: "start over")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem (image: img, style: .Plain, target: self, action: "startOver")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startOver() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewControllerAnimated(true)
        }
    }

    deinit {
        print("deallocation")
    }
}
