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
    let mapViewLat = "MapViewLat"
    let mapViewLong = "MapViewLong"
    let mapViewSpanLatDelta = "MapViewSpanLatDelta"
    let mapViewSpanLongDelta = "MapViewSpanLongDelta"
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        super.encodeRestorableStateWithCoder(coder)
        print("encodeRestorableStateWithCoder")
        coder.encodeDouble(mapView.region.center.latitude, forKey: mapViewLat)
        coder.encodeDouble(mapView.region.center.longitude, forKey: mapViewLong)
        coder.encodeDouble(mapView.region.span.latitudeDelta, forKey: mapViewSpanLatDelta)
        coder.encodeDouble(mapView.region.span.longitudeDelta, forKey: mapViewSpanLongDelta)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        super.decodeRestorableStateWithCoder(coder)
        print("decodeRestorableStateWithCoder")

        var center = CLLocationCoordinate2D()
        var span = MKCoordinateSpan()
        
        center.latitude = coder.decodeDoubleForKey(mapViewLat)
        center.longitude = coder.decodeDoubleForKey(mapViewLong)
        
        span.latitudeDelta = coder.decodeDoubleForKey(mapViewSpanLatDelta)
        span.longitudeDelta = coder.decodeDoubleForKey(mapViewSpanLongDelta)

        let region = MKCoordinateRegion(center: center, span: span)

        mapView.setRegion(region, animated: true)
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
