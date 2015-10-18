//
//  OTMAnnotation.swift
//  On The Map
//
//  Created by Tom Lai on 10/17/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import UIKit
import MapKit
class OTMAnnotation: NSObject, MKAnnotation {
    // Center latitude and longitude of the annotation view.
    // The implementation of this property must be KVO compliant.
    @objc var coordinate: CLLocationCoordinate2D
    
    // Title and subtitle for use by selection UI.
    @objc var title: String?
    @objc var subtitle: String?
    
    init(title:String, subtitle:String, coor: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        coordinate = coor
    }
}
