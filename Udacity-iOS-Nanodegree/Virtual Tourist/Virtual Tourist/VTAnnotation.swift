//
//  VTAnnotation.swift
//  Virtual Tourist
//
//  Created by Tom Lai on 1/19/16.
//  Copyright © 2016 Lai. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class VTAnnotation: NSManagedObject, MKAnnotation {
    @NSManaged var longitude: NSNumber!
    @NSManaged var latitude: NSNumber!
    @NSManaged @objc var title: String?
    @NSManaged @objc var subtitle: String?
    @NSManaged var images: [Image]
    @NSManaged var pageNumber: NSNumber!
    
    struct Keys {
        static let Longitude = "longitude"
        static let Latitude = "latitude"
        static let Title = "title"
        static let Subtitle = "subtitle"
        static let Images = "images"
        static let Page = "page"
    }
    
    @objc var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
        }
        set {
            latitude = NSNumber(double: coordinate.latitude)
            longitude = NSNumber(double: coordinate.longitude)
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("VTAnnotation", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        longitude = dictionary[Keys.Longitude] as! NSNumber
        latitude = dictionary[Keys.Latitude] as! NSNumber
        title = dictionary[Keys.Title] as? String
        subtitle = dictionary[Keys.Subtitle] as? String
        pageNumber = dictionary[Keys.Page] as! NSNumber
        
    }
}
