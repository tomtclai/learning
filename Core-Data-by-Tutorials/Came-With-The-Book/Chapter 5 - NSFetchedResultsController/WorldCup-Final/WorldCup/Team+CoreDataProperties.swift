//
//  Team+CoreDataProperties.swift
//  WorldCup
//
//  Created by Pietro Rea on 8/1/15.
//  Copyright © 2015 Razeware. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Team {

    @NSManaged var imageName: String?
    @NSManaged var losses: NSNumber?
    @NSManaged var qualifyingZone: String?
    @NSManaged var teamName: String?
    @NSManaged var wins: NSNumber?

}
