//
//  ViewController.swift
//  Dog Walk
//
//  Created by Pietro Rea on 7/17/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
  
  lazy var dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .ShortStyle
    formatter.timeStyle = .MediumStyle
    return formatter
    }()
  
  @IBOutlet var tableView: UITableView!
  var managedContext: NSManagedObjectContext!
  var currentDog: Dog!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.registerClass(UITableViewCell.self,
      forCellReuseIdentifier: "Cell")
    
    let dogEntity = NSEntityDescription.entityForName("Dog",
      inManagedObjectContext: managedContext)
    
    let dogName = "Fido"
    let dogFetch = NSFetchRequest(entityName: "Dog")
    dogFetch.predicate = NSPredicate(format: "name == %@", dogName)
    
    do {
      let results =
      try managedContext.executeFetchRequest(dogFetch) as! [Dog]
      
      if results.count > 0 {
        //Fido found, use Fido
        currentDog = results.first
      } else {
        //Fido not found, create Fido
        currentDog = Dog(entity: dogEntity!,
          insertIntoManagedObjectContext: managedContext)
        currentDog.name = dogName
        try managedContext.save()
      }
    } catch let error as NSError {
      print("Error: \(error) " +
        "description \(error.localizedDescription)")
    }
  }
  
  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return currentDog.walks!.count
  }
  
  func tableView(tableView: UITableView,
    titleForHeaderInSection section: Int) -> String? {
      return "List of Walks"
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath
    indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell =
      tableView.dequeueReusableCellWithIdentifier("Cell",
        forIndexPath: indexPath) as UITableViewCell
      
      //the last two statements have changed
      let walk = currentDog.walks![indexPath.row] as! Walk
      
      cell.textLabel!.text =
        dateFormatter.stringFromDate(walk.date!)
      
      return cell
  }
  
  func tableView(tableView: UITableView,
    canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      return true
  }
  
  func tableView(tableView: UITableView,
    commitEditingStyle
    editingStyle: UITableViewCellEditingStyle,
    forRowAtIndexPath indexPath: NSIndexPath) {
      
      if editingStyle == UITableViewCellEditingStyle.Delete {
        
        //1
        let walkToRemove =
        currentDog.walks![indexPath.row] as! Walk
        
        //2
        managedContext.deleteObject(walkToRemove)
        
        //3
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save: \(error)")
        }
        
        //4
        tableView.deleteRowsAtIndexPaths([indexPath],
          withRowAnimation: UITableViewRowAnimation.Automatic)
      }
  }
  
  
  @IBAction func add(sender: AnyObject) {
    
    //Insert a new Walk entity into Core Data
    let walkEntity = NSEntityDescription.entityForName("Walk",
      inManagedObjectContext: managedContext)
    
    let walk = Walk(entity: walkEntity!,
      insertIntoManagedObjectContext: managedContext)
    
    walk.date = NSDate()
    
    //Insert the new Walk into the Dog's walks set
    let walks = currentDog.walks!.mutableCopy()
      as! NSMutableOrderedSet
    
    walks.addObject(walk)
    
    currentDog.walks = walks.copy() as? NSOrderedSet
    
    //Save the managed object context
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save:\(error)")
    }
    
    //Reload table view
    tableView.reloadData()
  }
}

