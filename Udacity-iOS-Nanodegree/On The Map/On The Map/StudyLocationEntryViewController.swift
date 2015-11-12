//
//  StudyLocationEntryViewController.swift
//  On The Map
//
//  Created by Tom Lai on 10/19/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import UIKit
import CoreLocation
class StudyLocationEntryViewController: UIViewController {

    @IBOutlet weak var locationField: UITextField!
    var geocoder = CLGeocoder()
    var locationString : String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "showUrlEntryView" {
            if !locationField.text!.isEmpty {
                self.locationString = locationField.text
                return true
            } else {
                showOKAlert("No Address provided", subtitle: "Please type an address")
                return false
            }
        }
        return true
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUrlEntryView" {
            // TODO: do an interactive animation here, slide up to present
            let uev = segue.destinationViewController as! UrlEntryViewController
            geocoder.geocodeAddressString(locationString, completionHandler: { (placemark, error) in
                if let location = placemark?.first?.location {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    })
                    uev.location = location.coordinate
                    uev.locationString = self.locationString
                }
                // TODO: show alert if geocode failed
                if let error = error {
                    self.showOKAlert("Geocode Failed", subtitle: error.localizedDescription)
                }
            })
        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
}

extension StudyLocationEntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}