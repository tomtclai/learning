//
//  OTMStudent.swift
//  On The Map
//
//  Created by Tom Lai on 10/8/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//
import Foundation

struct OTMStudent {

    static var ListOfStudent: [OTMStudent]?

    // MARK: Initializers
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Float
    var longitude: Float
    var createdAt: String
    var updatedAt: String

    /* Construct a TMDBMovie from a dictionary */
    init(dictionary: [String: AnyObject]) {
        objectId = dictionary[ParseClient.JSONResponseKeyPaths.ObjectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeyPaths.UniqueKey] as! String
        firstName = dictionary[ParseClient.JSONResponseKeyPaths.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeyPaths.LastName] as! String
        mapString = dictionary[ParseClient.JSONResponseKeyPaths.MapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeyPaths.MediaURL] as! String
        latitude = dictionary[ParseClient.JSONResponseKeyPaths.Latitude] as! Float
        longitude = dictionary[ParseClient.JSONResponseKeyPaths.Longitude] as! Float
        createdAt = dictionary[ParseClient.JSONResponseKeyPaths.CreatedAt] as! String
        updatedAt = dictionary[ParseClient.JSONResponseKeyPaths.UpdatedAt] as! String
    }

    /* Helper: Given an array of dictionaries, convert them to an array of TMDBMovie objects */
    static func studentsFromResults(results: [[String: AnyObject]]) -> [OTMStudent] {
        var students = [OTMStudent]()

        for result in results {
            students.append(OTMStudent(dictionary: result))
        }

        return students
    }
}
