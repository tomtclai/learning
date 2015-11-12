//
//  UrlEntryViewController.swift
//  On The Map
//
//  Created by Tom Lai on 10/31/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import UIKit
import MapKit
class UrlEntryViewController: UIViewController {
    
    @IBOutlet weak var urlField: UITextField!
    var locationString : String!
    var location : CLLocationCoordinate2D! {
        didSet {
            let span = MKCoordinateSpanMake(0.20, 0.20)
            let region = MKCoordinateRegion(center: location, span: span)
            mapview.setRegion(region, animated: true)
        }
    }
    
    @IBOutlet weak var mapview: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        urlField.delegate = self

    }
    
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitTapped(sender: AnyObject) {
        UIActivityIndicatorViewController.sharedInstance.start()
        
        ParseClient.sharedInstance().postStudentLocation(locationString, mediaURL: urlField.text, latitude: location.latitude, longitude: location.longitude) { (result, error) -> Void in
            UIActivityIndicatorViewController.sharedInstance.stop()
            guard error == nil else {
                print(error)
                UIActivityIndicatorViewController.sharedInstance.stop()
                self.showOKAlert("Error Posting", subtitle: error!.localizedDescription)
                return
            }
            ParseClient.sharedInstance().locationObjectID = result
            print("ObjectID: \(result)")
            dispatch_async(dispatch_get_main_queue()) {
                self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}

extension UrlEntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}