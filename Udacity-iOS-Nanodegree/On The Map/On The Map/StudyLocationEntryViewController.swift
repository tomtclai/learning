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
    private var locationString : String!
    private var geocoder = CLGeocoder()
    private var location : CLLocationCoordinate2D?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    @IBAction func findOnTheMapTapped(sender: AnyObject) {
        if locationField.text!.isEmpty {
            showOKAlert("Error", subtitle: "Please type an address")
        } else {
            UIActivityIndicatorViewController.sharedInstance.start()
            self.locationString = locationField.text
            geocoder.geocodeAddressString(locationString, completionHandler: { (placemark, error) in
                UIActivityIndicatorViewController.sharedInstance.stop()
                if let location = placemark?.first?.location {
                    self.location = location.coordinate
                    self.performSegueWithIdentifier("showUrlEntryView", sender: sender)
                }
                if let error = error {
                    self.showOKAlert("Cannot geocode", subtitle: error.localizedDescription)
                }
            })
            
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUrlEntryView" {
            let uev = segue.destinationViewController as! UrlEntryViewController
            uev.locationString = self.locationString
            uev.location = self.location
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