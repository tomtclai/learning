//
//  Location.swift
//  Virtual Tourist
//
//  Created by Tom Lai on 1/19/16.
//  Copyright © 2016 Lai. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Location: NSManagedObject {
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
// Insert code here to add functionality to your managed object subclass
    var coordinate : CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude!.doubleValue, longitude: longitude!.doubleValue)
        }
        set(newCoordinate) {
            latitude = newCoordinate.latitude
            longitude = newCoordinate.longitude
        }
    }
}
