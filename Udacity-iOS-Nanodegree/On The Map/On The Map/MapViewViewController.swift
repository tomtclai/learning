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

    override func viewDidAppear(animated: Bool) {
        

        // Do any additional setup after loading the view.
    }
    
    func refreshAndReload(forced: Bool) {
        refreshListOfStudent(forced) { students -> Void in
            
            let annotations : [MKAnnotation]!
            
            for student in students {

                annotations.append()
            }
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.mapView.addAnnotations(<#T##annotations: [MKAnnotation]##[MKAnnotation]#>)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // There is no prototype in storyboard, dequeue might return nil and you will need to creat one
    //https://www.dropbox.com/s/dfrwwsydlwa8swd/Screenshot%202015-10-17%2014.31.19.png?dl=0
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "OTMAnnotation"
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        if view == nil {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
        }
        
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
