//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Tom Lai on 1/18/16.
//  Copyright © 2016 Lai. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var annotation: VTAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Fetch failed: \(error)")
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(fetchedResultsController.fetchedObjects as! [MKAnnotation])
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleLongPress(gestureRecognizer: UIGestureRecognizer){
        if (gestureRecognizer.state == .Began) {
            let touchPoint = gestureRecognizer.locationInView(mapView)
            let coordinateInMaps = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let annotationDictionary : [String:AnyObject] = [
                VTAnnotation.Keys.Longitude : NSNumber(double: coordinateInMaps.longitude),
                VTAnnotation.Keys.Latitude : NSNumber(double: coordinateInMaps.latitude),
                //TODO: make title the city name, subtitle country
                VTAnnotation.Keys.Title : String.localizedStringWithFormat("%.3f, %.3f", coordinateInMaps.latitude, coordinateInMaps.longitude),
                VTAnnotation.Keys.Page : NSNumber(integer: 1)
            ]
            dispatch_async(dispatch_get_main_queue()){
                let _ = VTAnnotation(dictionary: annotationDictionary, context: self.sharedContext)
                CoreDataStackManager.sharedInstance().saveContext()
            }
        }
    }
    
    // MARK: - state restoration
    let mapViewLat = "MapViewLat"
    let mapViewLong = "MapViewLong"
    let mapViewSpanLatDelta = "MapViewSpanLatDelta"
    let mapViewSpanLongDelta = "MapViewSpanLongDelta"
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        super.encodeRestorableStateWithCoder(coder)
        coder.encodeDouble(mapView.region.center.latitude, forKey: mapViewLat)
        coder.encodeDouble(mapView.region.center.longitude, forKey: mapViewLong)
        coder.encodeDouble(mapView.region.span.latitudeDelta, forKey: mapViewSpanLatDelta)
        coder.encodeDouble(mapView.region.span.longitudeDelta, forKey: mapViewSpanLongDelta)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        super.decodeRestorableStateWithCoder(coder)

        var center = CLLocationCoordinate2D()
        var span = MKCoordinateSpan()
        
        center.latitude = coder.decodeDoubleForKey(mapViewLat)
        center.longitude = coder.decodeDoubleForKey(mapViewLong)
        
        span.latitudeDelta = coder.decodeDoubleForKey(mapViewSpanLatDelta)
        span.longitudeDelta = coder.decodeDoubleForKey(mapViewSpanLongDelta)

        let region = MKCoordinateRegion(center: center, span: span)

        mapView.setRegion(region, animated: true)
    }

    // MARK: Segue
    let showPhotoAlbumSegueID = "showPhotoAlbum"
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showPhotoAlbumSegueID {
            guard let pavc = segue.destinationViewController as? PhotoAlbumViewController else {
                print("unexpected destionation viewcontroller")
                return
            }
            pavc.annotation = annotation
            pavc.span = mapView.region.span

        }
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: "VTAnnotation")
        request.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true), NSSortDescriptor(key: "longitude", ascending: true)]
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    

}

// MARK: UIViewControllerRestoration
extension TravelLocationsMapViewController : UIViewControllerRestoration {
    static func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject], coder: NSCoder) -> UIViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TravelLocationsMapViewController")
    }
}

// MARK: MKMapViewDelegate
extension TravelLocationsMapViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        annotation = view.annotation as! VTAnnotation
        performSegueWithIdentifier(showPhotoAlbumSegueID, sender: self)
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension TravelLocationsMapViewController : NSFetchedResultsControllerDelegate {
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        let pin = anObject as! VTAnnotation
        switch type {
        case .Insert:
            mapView.addAnnotation(pin)
        case .Delete:
            mapView.removeAnnotation(pin)
        case .Update:
            mapView.removeAnnotation(pin)
            mapView.addAnnotation(pin)
        default:
            return
        }
    }
    
}


