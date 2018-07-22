//
//  MainViewController.swift
//  Menu
//
//  Created by Mathew Sanders on 9/7/14.
//  Copyright (c) 2014 Mat. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    var transitionManager = TransitionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        transitionManager.sourceViewController = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let menu = segue.destinationViewController as! MenuViewController
        menu.transitioningDelegate = self.transitionManager

    }

    @IBAction func unwindToMainViewController (sender: UIStoryboardSegue) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
