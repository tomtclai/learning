//
//  ViewController.swift
//  Bubble Tea Finder
//
//  Created by Pietro Rea on 8/24/14.
//  Copyright (c) 2014 Pietro Rea. All rights reserved.
//

import UIKit

let filterViewControllerSegueIdentifier = "toFilterViewController"
let venueCellIdentifier = "VenueCell"

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var coreDataStack: CoreDataStack!
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == filterViewControllerSegueIdentifier {
    
    }
  }
  
  @IBAction func unwindToVenuListViewController(segue: UIStoryboardSegue) {
    
  }
}

extension ViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(venueCellIdentifier)!
    cell.textLabel!.text = "Bubble Tea Venue"
    cell.detailTextLabel!.text = "Price Info"
    
    return cell
  }
}
