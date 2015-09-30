/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import CoreData

class JournalListViewController:
  UITableViewController, NSFetchedResultsControllerDelegate,
    JournalEntryDelegate {

  var coreDataStack: CoreDataStack!
  lazy var fetchedResultController:
    NSFetchedResultsController =
      self.surfJournalfetchedResultController()
  
  @IBOutlet weak var exportButton: UIBarButtonItem!

  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  

  // MARK: - NSFetchedResultsController
  
  func surfJournalfetchedResultController()
    -> NSFetchedResultsController {
      
    fetchedResultController =
      NSFetchedResultsController(
        fetchRequest: surfJournalFetchRequest(),
        managedObjectContext: coreDataStack.context,
        sectionNameKeyPath: nil,
        cacheName: nil)
    fetchedResultController.delegate = self
    
    do {
      try fetchedResultController.performFetch()
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      abort()
    }
    
    return fetchedResultController
  }
  
  func surfJournalFetchRequest() -> NSFetchRequest {
      
    let fetchRequest =
      NSFetchRequest(entityName: "JournalEntry")
    fetchRequest.fetchBatchSize = 20
      
    let sortDescriptor =
      NSSortDescriptor(key: "date", ascending: false)
      
    fetchRequest.sortDescriptors = [sortDescriptor]
      
    return fetchRequest
  }
  
  
  // MARK: - NSFetchedResultsControllerDelegate
  
  func controllerDidChangeContent(controller:
    NSFetchedResultsController) {
      tableView.reloadData()
  }


  // MARK: - UITableViewDataSource

  override func numberOfSectionsInTableView(
    tableView: UITableView) -> Int {

    return fetchedResultController.sections!.count
  }

  override func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {

    return
      fetchedResultController.sections![section].numberOfObjects
  }

  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath)
    -> UITableViewCell {

    let cell =
      tableView.dequeueReusableCellWithIdentifier("Cell",
        forIndexPath: indexPath) as! SurfEntryTableViewCell

      configureCell(cell, indexPath: indexPath)

    return cell
  }
  
  func configureCell(cell: SurfEntryTableViewCell,
    indexPath:NSIndexPath) {
    
    let surfJournalEntry =
      fetchedResultController.objectAtIndexPath(indexPath)
        as! JournalEntry
    
    cell.dateLabel.text = surfJournalEntry.stringForDate()
    
    if let rating = surfJournalEntry.rating?.intValue {
      switch rating {
      case 1:
        cell.starOneFilledImageView.hidden = false
        cell.starTwoFilledImageView.hidden = true
        cell.starThreeFilledImageView.hidden = true
        cell.starFourFilledImageView.hidden = true
        cell.starFiveFilledImageView.hidden = true
      case 2:
        cell.starOneFilledImageView.hidden = false
        cell.starTwoFilledImageView.hidden = false
        cell.starThreeFilledImageView.hidden = true
        cell.starFourFilledImageView.hidden = true
        cell.starFiveFilledImageView.hidden = true
      case 3:
        cell.starOneFilledImageView.hidden = false
        cell.starTwoFilledImageView.hidden = false
        cell.starThreeFilledImageView.hidden = false
        cell.starFourFilledImageView.hidden = true
        cell.starFiveFilledImageView.hidden = true
      case 4:
        cell.starOneFilledImageView.hidden = false
        cell.starTwoFilledImageView.hidden = false
        cell.starThreeFilledImageView.hidden = false
        cell.starFourFilledImageView.hidden = false
        cell.starFiveFilledImageView.hidden = true
      case 5:
        cell.starOneFilledImageView.hidden = false
        cell.starTwoFilledImageView.hidden = false
        cell.starThreeFilledImageView.hidden = false
        cell.starFourFilledImageView.hidden = false
        cell.starFiveFilledImageView.hidden = false
      default :
        cell.starOneFilledImageView.hidden = true
        cell.starTwoFilledImageView.hidden = true
        cell.starThreeFilledImageView.hidden = true
        cell.starFourFilledImageView.hidden = true
        cell.starFiveFilledImageView.hidden = true
      }
    }
  }

  override func tableView(tableView: UITableView,
  commitEditingStyle editingStyle: UITableViewCellEditingStyle,
    forRowAtIndexPath indexPath: NSIndexPath) {

    if editingStyle == .Delete {
      let surfJournalEntry =
        fetchedResultController.objectAtIndexPath(indexPath)
          as! JournalEntry
      coreDataStack.context.deleteObject(surfJournalEntry)
      coreDataStack.saveContext()
    }
  }
  
  override func tableView(tableView: UITableView,
    heightForRowAtIndexPath indexPath: NSIndexPath)
      -> CGFloat {
    return 44;
  }
  
  
  // MARK: - JournalEntryDelegate

  func didFinishViewController(
    viewController:JournalEntryViewController, didSave:Bool) {

    // 1
    if didSave {
      // 2
      let context = viewController.context
      context.performBlock({ () -> Void in
        if context.hasChanges {
          do {
            try context.save()
          } catch {
            let nserror = error as NSError
            print("Error: \(nserror.localizedDescription)")
            abort()
          }
        }

        // 3
        self.coreDataStack.saveContext()
      })
    }
      
    // 4
    dismissViewControllerAnimated(true, completion: {})
  }

  
  // MARK: - Segues
  
  override func prepareForSegue(segue: UIStoryboardSegue,
    sender: AnyObject?) {
      
      // 1
      if segue.identifier == "SegueListToDetail" {
        
        // 2
        let indexPath = tableView.indexPathForSelectedRow
        let surfJournalEntry =
          fetchedResultController.objectAtIndexPath(
            indexPath!) as! JournalEntry
        
        //3
        let navigationController =
          segue.destinationViewController as!
            UINavigationController
        let detailViewController =
          navigationController.topViewController as!
            JournalEntryViewController
        
        //4
        detailViewController.journalEntry = surfJournalEntry
        detailViewController.context
          = surfJournalEntry.managedObjectContext
        detailViewController.delegate = self
        
      } else if segue.identifier == "SegueListToDetailAdd" {
        
        let navigationController =
          segue.destinationViewController as!
            UINavigationController
        let detailViewController =
        navigationController.topViewController as!
        JournalEntryViewController
        
        
        let journalEntryEntity =
          NSEntityDescription.entityForName("JournalEntry",
            inManagedObjectContext: coreDataStack.context)
        let newJournalEntry =
          JournalEntry(entity: journalEntryEntity!,
            insertIntoManagedObjectContext:
              coreDataStack.context)
        
        detailViewController.journalEntry = newJournalEntry
        detailViewController.context
          = newJournalEntry.managedObjectContext
        detailViewController.delegate = self
      }
  }
  
  
  // MARK: - Target Action
  
  @IBAction func exportButtonTapped(sender: AnyObject) {
    exportCSVFile()
  }
  

  // MARK: - Export
  
  func activityIndicatorBarButtonItem() -> UIBarButtonItem {
    let activityIndicator =
      UIActivityIndicatorView(activityIndicatorStyle:
        UIActivityIndicatorViewStyle.Gray)
    let barButtonItem =
      UIBarButtonItem(customView: activityIndicator)
    activityIndicator.startAnimating()
    
    return barButtonItem
  }
  
  func exportBarButtonItem() -> UIBarButtonItem {
    
    return UIBarButtonItem(
      title: "Export", style: UIBarButtonItemStyle.Plain,
      target: self, action: "exportButtonTapped:")
  }
  
  func showExportFinishedAlertView(exportPath: String) {
    
    let message =
      "The exported CSV file can be found at \(exportPath)"
    let alertController = UIAlertController(title: "Export Finished",
      message: message, preferredStyle: .Alert)
    let okAction = UIAlertAction(title: "OK", style: .Default,
      handler: nil)
    alertController.addAction(okAction)
    
    presentViewController(alertController, animated: true,
      completion: nil)
  }
  
  func exportCSVFile() {
    
    navigationItem.leftBarButtonItem =
      activityIndicatorBarButtonItem()
    
    // 1
    let results: [AnyObject]
    do {
      results = try coreDataStack.context.executeFetchRequest(
            self.surfJournalFetchRequest())
    } catch {
      let nserror = error as NSError
      print("ERROR: \(nserror)")
      results = []
    }

    // 2
    let exportFilePath =
      NSTemporaryDirectory() + "export.csv"
    let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
    NSFileManager.defaultManager().createFileAtPath(
      exportFilePath, contents: NSData(), attributes: nil)
    
    // 3
    let fileHandle: NSFileHandle?
    do {
      fileHandle = try NSFileHandle(forWritingToURL: exportFileURL)
    } catch {
      let nserror = error as NSError
      print("ERROR: \(nserror)")
      fileHandle = nil
    }

    if let fileHandle = fileHandle {
      // 4
      for object in results {
        let journalEntry = object as! JournalEntry
        
        fileHandle.seekToEndOfFile()
        let csvData = journalEntry.csv().dataUsingEncoding(
          NSUTF8StringEncoding, allowLossyConversion: false)
        fileHandle.writeData(csvData!)
      }
      
      // 5
      fileHandle.closeFile()
  
      print("Export Path: \(exportFilePath)")
      self.navigationItem.leftBarButtonItem =
        self.exportBarButtonItem()
      self.showExportFinishedAlertView(exportFilePath)
    } else {
      self.navigationItem.leftBarButtonItem =
        self.exportBarButtonItem()
    }

  }
}
