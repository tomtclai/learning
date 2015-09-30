//
//  AppDelegate.swift
//  Dog Walk
//
//  Created by Pietro Rea on 7/17/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  lazy var coreDataStack = CoreDataStack()
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions
    launchOptions: [NSObject: AnyObject]?) -> Bool {
      
    let navigationController =
    self.window!.rootViewController as! UINavigationController
    
    let viewController =
    navigationController.topViewController as! ViewController
    
    viewController.managedContext = coreDataStack.context
    
    return true
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    coreDataStack.saveContext()
  }
  
  func applicationWillTerminate(application: UIApplication) {
    coreDataStack.saveContext()
  }
}

