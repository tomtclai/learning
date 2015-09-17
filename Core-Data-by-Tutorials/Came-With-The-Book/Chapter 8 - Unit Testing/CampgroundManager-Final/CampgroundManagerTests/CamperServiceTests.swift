//
//  CamperServiceTests.swift
//  CampgroundManager
//
//  Created by Richard Turton on 11/09/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit
import XCTest
import CampgroundManager
import CoreData

class CamperServiceTests: XCTestCase {
  
  var camperService: CamperService!
  var coreDataStack: CoreDataStack!
  
  
  override func setUp() {
    super.setUp()
    
    coreDataStack = TestCoreDataStack()
    camperService = CamperService(
      managedObjectContext: coreDataStack.mainContext!,
      coreDataStack: coreDataStack)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
    coreDataStack = nil
    camperService = nil
  }
  
  func testRootContextIsSavedAfterAddingCamper() {
    
    //1
    let expectRoot =
    self.expectationForNotification(
      NSManagedObjectContextDidSaveNotification, object:
      coreDataStack.rootContext){
        notification in
        return true
    }
    
    //2
    let camper = camperService.addCamper("Bacon Lover",
      phoneNumber: "910-543-9000")
    
    //3
    self.waitForExpectationsWithTimeout(2.0){
      error in
      XCTAssertNil(error, "Save did not occur")
    }
    
  }
  
  func testAddCamper() {
    
    let camper = camperService.addCamper("Bacon Lover",
      phoneNumber: "910-543-9000")
    
    XCTAssertNotNil(camper, "Camper should not be nil")
    XCTAssertTrue(camper?.fullName == "Bacon Lover")
    XCTAssertTrue(camper?.phoneNumber == "910-543-9000")

  }

  
}
