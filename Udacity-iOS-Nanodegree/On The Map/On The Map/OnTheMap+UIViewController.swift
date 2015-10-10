//
//  onthemap+UIViewController.swift
//  On The Map
//
//  Created by Tom Lai on 10/10/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import UIKit

extension UIViewController {
 
    @IBAction func logoutTapped(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().deleteSession { (sessionID, error) -> Void in
            if let error = error {
                let alert = UIAlertController(title: "Error Logging out", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
}