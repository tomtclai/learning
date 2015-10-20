//
//  WhereAreYouStudyingTodayViewController.swift
//  On The Map
//
//  Created by Tom Lai on 10/19/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import UIKit

class WhereAreYouStudyingTodayViewController: UIViewController {

    @IBOutlet weak var locationField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
