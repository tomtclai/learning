//
//  CampSiteServiceTests.swift
//  CampgroundManager
//
//  Created by Richard Turton on 11/09/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit
import XCTest
import CampgroundManager
import CoreData

class CampSiteServiceTests: XCTestCase {
  var campSiteService: CampSiteService!
  var coreDataStack: CoreDataStack!
  
  override func setUp() {
    super.setUp()
    
    coreDataStack = TestCoreDataStack()
    campSiteService = CampSiteService(managedObjectContext:
      coreDataStack.mainContext!, coreDataStack:
      coreDataStack)
  }
  
  override func tearDown() {
    super.tearDown()
    
    campSiteService = nil
    coreDataStack = nil
  }
  
  func testRootContextIsSavedAfterAddingCampsite(){
    
    let expectRoot = self.expectationForNotification(
      NSManagedObjectContextDidSaveNotification, object:
      coreDataStack.rootContext){
        notification in
        return true
    }
    
    var campSite = campSiteService.addCampSite(1, electricity:
      true, water: true)
    
    self.waitForExpectationsWithTimeout(2.0){
      error in
      XCTAssertNil(error, "Save did not occur")
    }
    
  }
  
  func testAddCampSite() {

    let campSite = campSiteService.addCampSite(1, electricity:
      true, water: true)
    
    XCTAssertTrue(campSite.siteNumber == 1, "Site number should be 1")
    XCTAssertTrue(campSite.electricity.boolValue, "Site should have electricity")
    XCTAssertTrue(campSite.water.boolValue, "Site should have water")
  }
  
  func testGetCampSiteNoSites() {
    var campSite = campSiteService?.getCampSite(1)
    
    XCTAssertNil(campSite, "No campsite should be returned")
  }
  
  func testGetCampSiteWithMatchingSiteNumber() {
    
    campSiteService.addCampSite(1, electricity: true, water:
      true)
    
    let campSite = campSiteService.getCampSite(1)
    
    XCTAssertNotNil(campSite, "A campsite should be returned")
  }

  func testGetCampSiteNoMatchingSiteNumber() {
    campSiteService.addCampSite(1, electricity: true, water:
      true)
    
    let campSite = campSiteService.getCampSite(2)
    
    XCTAssertNil(campSite, "No campsite should be returned")
  }
  
  func testGetCampSitesNoSites() {
    let sites = campSiteService.getCampSites();
    
    XCTAssertTrue(sites.count == 0, "There should be no sites.")
  }

  func testGetCampSitesOneSite() {
    
    campSiteService.addCampSite(1, electricity: true, water: true)
    
    let sites = campSiteService.getCampSites();
    
    XCTAssertTrue(sites.count == 1, "There should be one site.")
  }
  
  func testGetCampSitesMultipleSite() {
    
    campSiteService.addCampSite(1, electricity: true, water: true)
    campSiteService.addCampSite(2, electricity: true, water: true)
    
    let sites = campSiteService?.getCampSites();
    
    XCTAssertTrue(sites?.count == 2, "There should be two sites.")
  }
  
  func testDeleteCampSite() {
    
    var campSite = campSiteService.addCampSite(1, electricity: true, water: true)
    
    var fetchedCampSite = campSiteService.getCampSite(1)
    
    XCTAssertNotNil(fetchedCampSite, "Site should exist")
    
    campSiteService.deleteCampSite(1)
    
    fetchedCampSite = campSiteService.getCampSite(1)
    
    XCTAssertNil(fetchedCampSite, "Site shouldn't exist")
  }
  
  func testGetNextCampSiteNumberNoSites() {
    let siteNumber = campSiteService.getNextCampSiteNumber()
    
    XCTAssertTrue(siteNumber == 1, "This should be the first campsite number")
  }
  
  func testGetNextCampSiteNumberOneSite() {
    
    campSiteService.addCampSite(1, electricity: true, water: true)
    
    let siteNumber = campSiteService.getNextCampSiteNumber()
    
    XCTAssertTrue(siteNumber == 2, "This should be the second campsite number")
  }
  
  func testGetNextCampSiteNumberOneSiteGapFrom1() {
    
    campSiteService.addCampSite(10, electricity: true, water: true)    
    let siteNumber = campSiteService.getNextCampSiteNumber()
    
    XCTAssertTrue(siteNumber == 11, "This should be the second campsite number")
  }
  
  func testGetNextCampSiteNumberMultipleSites() {
    
    campSiteService.addCampSite(1, electricity: true, water: true)
    campSiteService.addCampSite(10, electricity: true, water: true)
    campSiteService.addCampSite(30, electricity: true, water: true)
    campSiteService.addCampSite(31, electricity: true, water: true)
    
    let siteNumber = campSiteService.getNextCampSiteNumber()
    
    XCTAssertTrue(siteNumber == 32, "This should be the fifth campsite number")
  }

}
