//
//  Dog.swift
//  Dog Walk
//
//  Created by Pietro Rea on 4/20/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import Foundation
import CoreData

class Dog: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var walks: NSOrderedSet

}
