//
//  ReservationServiceTests.swift
//  CampgroundManager
//
//  Created by Richard Turton on 11/09/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import Foundation
import CoreData
import XCTest
import CampgroundManager

class ReservationServiceTests: XCTestCase {
  var campSiteService: CampSiteService!
  var camperService: CamperService!
  var reservationService: ReservationService!
  var coreDataStack: CoreDataStack!
  
  override func setUp() {
    super.setUp()
    coreDataStack = TestCoreDataStack()
    camperService = CamperService(managedObjectContext:
      coreDataStack.mainContext!, coreDataStack:
      coreDataStack)
    campSiteService = CampSiteService(managedObjectContext:
      coreDataStack.mainContext!, coreDataStack:
      coreDataStack)
    reservationService = ReservationService(
      managedObjectContext: coreDataStack.mainContext!,
      coreDataStack: coreDataStack)
  }
  
  override func tearDown() {
    super.tearDown()
    
    camperService = nil
    campSiteService = nil
    reservationService = nil
    coreDataStack = nil
  }
  
  func testReserveCampSitePositiveNumberOfDays() {
    let camper = camperService.addCamper("Johnny Appleseed",
      phoneNumber: "408-555-1234")!
    let campSite = campSiteService.addCampSite(15, electricity:
      false, water: false)
    
    let result = reservationService.reserveCampSite(campSite,
      camper: camper, date: NSDate(), numberOfNights: 5)
    
    XCTAssertNotNil(result.reservation, "Reservation should not be nil")
      XCTAssertNil(result.error, "No error should be present")
      XCTAssertTrue(result.reservation?.status == "Reserved",
        "Status should be Reserved")
  }
  
  func testReserveCampSiteNegativeNumberOfDays() {
    let camper = camperService.addCamper("Johnny Appleseed",
      phoneNumber: "408-555-1234")!
    let campSite = campSiteService!.addCampSite(15, electricity:
      false, water: false)
    
    let result = reservationService!.reserveCampSite(campSite,
      camper: camper, date: NSDate(), numberOfNights: -1)
    
    XCTAssertNotNil(result.reservation, "Reservation should not be nil")
    XCTAssertNotNil(result.error, "No error should be present")
    XCTAssertTrue(result.error?.userInfo?["Problem"] as? NSString
      == "Invalid number of days", "Error problem should be present")
    XCTAssertTrue(result.reservation?.status == "Invalid", "Status should be Invalid")
  }

}

