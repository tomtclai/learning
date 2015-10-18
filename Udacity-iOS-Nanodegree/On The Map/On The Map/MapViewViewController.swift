//
//  MapViewViewController.swift
//  On The Map
//
//  Created by Tom Lai on 10/10/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
// 


import UIKit
import MapKit
class MapViewViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshAndReload(false)
        super.viewDidAppear(animated)
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        refreshAndReload(true)
    }
    
    func refreshAndReload(forced: Bool) {
        refreshListOfStudent(forced) { students -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.mapView.removeAnnotations(self.mapView.annotations)
            })
            
            var annotations = [OTMAnnotation]()
            
            for student in students {
                let name = student.firstName + " " + student.lastName
                let coor = CLLocationCoordinate2D(latitude: Double(student.latitude), longitude: Double(student.longitude))
                annotations.append(OTMAnnotation(title: name, subtitle: student.mediaURL, coor: coor))
            }
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.mapView.addAnnotations(annotations)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "OTMAnnotation"
        var view: MKPinAnnotationView?  = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as! MKPinAnnotationView!
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view!.canShowCallout = true
        }
        view!.annotation = annotation
        
        return view
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        // Don't display a button if I can't open
        if let urlString = view.annotation!.subtitle {
            if let url = NSURL(string: urlString!) {
                if UIApplication.sharedApplication().canOpenURL(url){
                    view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
                }
            }
        }
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let subtitleURL = view.annotation!.subtitle!
        let url = NSURL(string: subtitleURL!)!
        
        
        UIApplication.sharedApplication().openURL(url)
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
