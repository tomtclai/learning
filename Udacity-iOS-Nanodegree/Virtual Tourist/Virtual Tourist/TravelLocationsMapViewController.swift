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
            //TODO: add it to persistent store too
            mapView.addAnnotation(annotation)
        }
    }
}
extension TravelLocationsMapViewController : MKMapViewDelegate {
    
}
