//
//  onthemap+UIViewController.swift
//  On The Map
//
//  Created by Tom Lai on 10/10/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
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
        
        FBSDKLoginManager().logOut()
        
    }
    
    func refreshListOfStudent(forced: Bool, completionHandler:( [OTMStudent] -> Void) ) {
        if forced || OTMStudent.ListOfStudent==nil {
            ParseClient.sharedInstance().getStudentLocations { (result, error) -> Void in
                let result = OTMStudent.studentsFromResults(result as! [[String : AnyObject]])
                OTMStudent.ListOfStudent = result
                completionHandler(result)
            }
        } else {
            completionHandler(OTMStudent.ListOfStudent!)
        }
    }

    
    func showOKAlert(title: String, subtitle:String) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}