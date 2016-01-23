//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Tom Lai on 1/18/16.
//  Copyright © 2016 Lai. All rights reserved.
//

import UIKit
import MapKit
class TravelLocationsMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleLongPress(gestureRecognizer: UIGestureRecognizer){
        if (gestureRecognizer.state == .Began) {
            let touchPoint = gestureRecognizer.locationInView(mapView)
            let coordinateInMaps = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let annotation = VTAnnotation(coordinate: coordinateInMaps)
            
            let title  = String.localizedStringWithFormat("%.3f, %.3f", coordinateInMaps.latitude, coordinateInMaps.longitude)
            annotation.title = title
            //TODO: add it to persistent store too
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    // MARK: state restoration
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        super.encodeRestorableStateWithCoder(coder)
        print("encodeRestorableStateWithCoder")
        coder.encodeObject(mapView, forKey: "MapView")
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        super.decodeRestorableStateWithCoder(coder)
        print("decodeRestorableStateWithCoder")
        self.mapView = coder.decodeObjectForKey("MapView") as! MKMapView
    }

}
extension TravelLocationsMapViewController : UIViewControllerRestoration {
    static func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject], coder: NSCoder) -> UIViewController? {
        print("viewControllerWithRestorationIdentifierPath")
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TravelLocationsMapViewController")
    }
}
extension TravelLocationsMapViewController : MKMapViewDelegate {

}
