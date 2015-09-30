//
//  ViewController.swift
//  HitList
//
//  Created by Pietro Rea on 9/17/15.
//  Copyright © 2015 Pietro. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  var people = [NSManagedObject]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\"The List\""
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    //1
    let appDelegate =
    UIApplication.sharedApplication().delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    //2
    let fetchRequest = NSFetchRequest(entityName: "Person")
    
    //3
    do {
      let results =
      try managedContext.executeFetchRequest(fetchRequest)
      people = results as! [NSManagedObject]
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: UITableViewDataSource
  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return people.count
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath
    indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell =
      tableView.dequeueReusableCellWithIdentifier("Cell")
      
      let person = people[indexPath.row]
      
      cell!.textLabel!.text =
        person.valueForKey("name") as? String
      
      return cell!
  }
  
  @IBAction func addName(sender: AnyObject) {
    
    let alert = UIAlertController(title: "New Name",
      message: "Add a new name",
      preferredStyle: .Alert)
    
    let saveAction = UIAlertAction(title: "Save",
      style: .Default,
      handler: { (action:UIAlertAction) -> Void in
        
        let textField = alert.textFields!.first
        self.saveName(textField!.text!)
        self.tableView.reloadData()
    })
    
    let cancelAction = UIAlertAction(title: "Cancel",
      style: .Default) { (action: UIAlertAction) -> Void in
    }
    
    alert.addTextFieldWithConfigurationHandler {
      (textField: UITextField) -> Void in
    }
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    presentViewController(alert,
      animated: true,
      completion: nil)
  }
  
  func saveName(name: String) {
    //1
    let appDelegate =
    UIApplication.sharedApplication().delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    //2
    let entity =  NSEntityDescription.entityForName("Person",
    inManagedObjectContext:managedContext)
    
    let person = NSManagedObject(entity: entity!,
    insertIntoManagedObjectContext: managedContext)
    
    //3
    person.setValue(name, forKey: "name")
    
    //4
    do {
    try managedContext.save()
    //5
    people.append(person)
  } catch let error as NSError  {
    print("Could not save \(error), \(error.userInfo)")
    }
  }
  
  
}

