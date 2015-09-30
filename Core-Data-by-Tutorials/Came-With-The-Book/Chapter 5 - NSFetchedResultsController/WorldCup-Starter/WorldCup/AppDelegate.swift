//
//  AppDelegate.swift
//  WorldCup
//
//  Created by Pietro Rea on 8/2/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  lazy var  coreDataStack = CoreDataStack()

  func application(application: UIApplication,
    didFinishLaunchingWithOptions
    launchOptions: [NSObject: AnyObject]?) -> Bool {
      
      importJSONSeedDataIfNeeded()
      
      let navController = window!.rootViewController as! UINavigationController
      let viewController = navController.topViewController as! ViewController
      viewController.coreDataStack = coreDataStack
      
      return true
  }
  
  func applicationWillTerminate(application: UIApplication) {
    coreDataStack.saveContext()
  }
  
  
  func importJSONSeedDataIfNeeded() {
    
    let fetchRequest = NSFetchRequest(entityName: "Team")
    var error:NSError? = nil
    
    let count = coreDataStack.context
      .countForFetchRequest(fetchRequest, error: &error)
    
    if count == 0 {
      importJSONSeedData()
    }
  }
  
  func importJSONSeedData() {
    let jsonURL = NSBundle.mainBundle().URLForResource("seed", withExtension: "json")
    let jsonData = NSData(contentsOfURL: jsonURL!)
    
    do {
      let jsonArray = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .AllowFragments) as! NSArray
      let entity = NSEntityDescription.entityForName("Team", inManagedObjectContext: coreDataStack.context)
      
      for jsonDictionary in jsonArray {
        let teamName = jsonDictionary["teamName"] as! String
        let zone = jsonDictionary["qualifyingZone"] as! String
        let imageName = jsonDictionary["imageName"] as! String
        let wins = jsonDictionary["wins"] as! NSNumber
        
        let team = Team(entity: entity!,
          insertIntoManagedObjectContext: coreDataStack.context)
        team.teamName = teamName
        team.imageName = imageName
        team.qualifyingZone = zone
        team.wins = wins
      }
      
      coreDataStack.saveContext()
      print("Imported \(jsonArray.count) teams")
      
    } catch let error as NSError {
      print("Error importing teams: \(error)")
    }
  }
}

