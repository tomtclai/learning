//
//  AppDelegate.swift
//  Moody
//
//  Created by Florian on 07/05/15.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var persistentContainer: NSPersistentContainer!
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        createMoodyContainer { container in
            self.persistentContainer = container
          // Swap out the initial VC, it is just a placeholder until store is loaded
            let storyboard = self.window?.rootViewController?.storyboard
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "RootViewController") as? RootViewController
                else { fatalError("Cannot instantiate root view controller") }
          // set managed object context on VC
            vc.managedObjectContext = container.viewContext
          // install it as the root VC
            self.window?.rootViewController = vc
        }
        return true
    }
}
