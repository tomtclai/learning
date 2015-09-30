//
//  ViewController.swift
//  WorldCup
//
//  Created by Pietro Rea on 8/2/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit

private let teamCellIdentifier = "teamCellReuseIdentifier"

class ViewController: UIViewController {
  
  var coreDataStack: CoreDataStack!
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var addButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
  }
  
  func configureCell(cell: TeamCell, indexPath: NSIndexPath) {
    cell.flagImageView.backgroundColor = UIColor.blueColor()
    cell.teamLabel.text = "Team Name"
    cell.scoreLabel.text = "Wins: 0"
  }
}

extension ViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView
    (tableView: UITableView) -> Int {
      
      return 1
  }
  
  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      
      return 20
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
}

extension ViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
  }
}
