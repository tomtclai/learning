//
//  ViewController.swift
//  WorldCup
//
//  Created by Pietro Rea on 8/2/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit
import CoreData

private let teamCellIdentifier = "teamCellReuseIdentifier"

class ViewController: UIViewController {
  
  var coreDataStack: CoreDataStack!
  var fetchedResultsController: NSFetchedResultsController!
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var addButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //1
    let fetchRequest = NSFetchRequest(entityName: "Team")
    
    let zoneSort =
    NSSortDescriptor(key: "qualifyingZone", ascending: true)
    let scoreSort =
    NSSortDescriptor(key: "wins", ascending: false)
    let nameSort =
    NSSortDescriptor(key: "teamName", ascending: true)
    
    fetchRequest.sortDescriptors = [zoneSort, scoreSort, nameSort]
    
    //2
    fetchedResultsController =
      NSFetchedResultsController(fetchRequest: fetchRequest,
        managedObjectContext: coreDataStack.context,
        sectionNameKeyPath: "qualifyingZone",
        cacheName: "worldCup")
    
    fetchedResultsController.delegate = self
    
    //3
    do {
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
    }
  }
  
  func configureCell(cell: TeamCell, indexPath: NSIndexPath) {
    let team =
    fetchedResultsController.objectAtIndexPath(indexPath)
      as! Team
    
    cell.flagImageView.image = UIImage(named: team.imageName!)
    cell.teamLabel.text = team.teamName
    cell.scoreLabel.text = "Wins: \(team.wins!)"
  }
}

extension ViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView
    (tableView: UITableView) -> Int {
      return fetchedResultsController.sections!.count
  }
  
  func tableView(tableView: UITableView,
    titleForHeaderInSection section: Int) -> String? {
      let sectionInfo =
      fetchedResultsController.sections![section]
      return sectionInfo.name
  }
  
  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      let sectionInfo =
      fetchedResultsController.sections![section]
      return sectionInfo.numberOfObjects
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath)
    -> UITableViewCell {
      
      let cell =
      tableView.dequeueReusableCellWithIdentifier(
        teamCellIdentifier, forIndexPath: indexPath)
        as! TeamCell
      
      configureCell(cell, indexPath: indexPath)
      
      return cell
  }
  
  override func motionEnded(motion: UIEventSubtype,
    withEvent event: UIEvent?) {
      
      if motion == .MotionShake {
        addButton.enabled = true
      }
      
  }
  
  @IBAction func addTeam(sender: AnyObject) {
    let alert = UIAlertController(title: "Secret Team",
      message: "Add a new team",
      preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addTextFieldWithConfigurationHandler {
      (textField: UITextField!) in
      textField.placeholder = "Team Name"
    }
    alert.addTextFieldWithConfigurationHandler {
      (textField: UITextField!) in
      textField.placeholder = "Qualifying Zone"
    }
    
    alert.addAction(UIAlertAction(title: "Save",
      style: .Default, handler: { (action: UIAlertAction!) in
        print("Saved")
        
        let nameTextField = alert.textFields!.first
        let zoneTextField = alert.textFields![1]
        
        let team =
        NSEntityDescription.insertNewObjectForEntityForName("Team",
          inManagedObjectContext: self.coreDataStack.context)
          as! Team
        
        team.teamName = nameTextField!.text
        team.qualifyingZone = zoneTextField.text
        team.imageName = "wenderland-flag"
        
        self.coreDataStack.saveContext()
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel",
      style: .Default, handler: { (action: UIAlertAction!) in
        print("Cancel")
    }))
    
    presentViewController(alert, animated: true,
      completion: nil)
  }
}

extension ViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
      let team =
      fetchedResultsController.objectAtIndexPath(indexPath)
        as! Team
      
      let wins = team.wins!.integerValue
      team.wins = NSNumber(integer: wins + 1)
      coreDataStack.saveContext()
  }
}

extension ViewController: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(controller:
    NSFetchedResultsController) {
      tableView.beginUpdates()
  }
  
  func controller(controller: NSFetchedResultsController,
    didChangeObject anObject: AnyObject,
    atIndexPath indexPath: NSIndexPath?,
    forChangeType type: NSFetchedResultsChangeType,
    newIndexPath: NSIndexPath?) {
      
      switch type {
      case .Insert:
        tableView.insertRowsAtIndexPaths([newIndexPath!],
          withRowAnimation: .Automatic)
      case .Delete:
        tableView.deleteRowsAtIndexPaths([indexPath!],
          withRowAnimation: .Automatic)
      case .Update:
        let cell = tableView.cellForRowAtIndexPath(indexPath!)
          as! TeamCell
        configureCell(cell, indexPath: indexPath!)
      case .Move:
        tableView.deleteRowsAtIndexPaths([indexPath!],
          withRowAnimation: .Automatic)
        tableView.insertRowsAtIndexPaths([newIndexPath!],
          withRowAnimation: .Automatic)
      }
  }
  
  func controllerDidChangeContent(controller:
    NSFetchedResultsController) {
      tableView.endUpdates()
  }
  
  func controller(controller: NSFetchedResultsController,
    didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
    atIndex sectionIndex: Int,
    forChangeType type: NSFetchedResultsChangeType) {
      
      let indexSet = NSIndexSet(index: sectionIndex)
      
      switch type {
      case .Insert:
        tableView.insertSections(indexSet,
          withRowAnimation: .Automatic)
      case .Delete:
        tableView.deleteSections(indexSet,
          withRowAnimation: .Automatic)
      default :
        break
      }
  }
  
}
