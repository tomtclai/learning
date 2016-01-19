//
//  VTAnnotation.swift
//  Virtual Tourist
//
//  Created by Tom Lai on 1/19/16.
//  Copyright © 2016 Lai. All rights reserved.
//

import UIKit
import MapKit
class VTAnnotation: NSObject, MKAnnotation {
    @objc var coordinate: CLLocationCoordinate2D
    @objc var title: String?
    @objc var subtitle: String?

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
