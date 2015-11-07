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
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelTapped(sender: AnyObject) {
        parentViewController?.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func submitTapped(sender: AnyObject) {
        ParseClient.sharedInstance().postStudentLocation(locationString, mediaURL: urlField.text, latitude: location.latitude, longitude: location.longitude) { (result, error) -> Void in
            if let objectID = result[ParseClient.JSONResponseKeyPaths.ObjectId] as? String {
                ParseClient.sharedInstance().locationObjectID = objectID
                print("ObjectID: \(ParseClient.JSONResponseKeyPaths.ObjectId)")
            } else {
                print("No \(ParseClient.JSONResponseKeyPaths.ObjectId) in \(result)")
            }
        }
    }
}
