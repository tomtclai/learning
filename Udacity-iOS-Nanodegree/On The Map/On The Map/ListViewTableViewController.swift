//
//  ListViewTableViewController.swift
//  On The Map
//
//  Created by Tom Lai on 10/10/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import UIKit

class ListViewTableViewController: UITableViewController {

    override func viewDidAppear(animated: Bool) {
        refreshAndReload(false)
        super.viewDidAppear(animated)
    }

    @IBAction func refresh(sender: UIBarButtonItem) {
        refreshAndReload(true)
    }
    
    func refreshAndReload(forced: Bool) {
        refreshListOfStudent(forced) { students -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if OTMStudent.ListOfStudent == nil {
            return 0
        }
        return OTMStudent.ListOfStudent!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OTMCell", forIndexPath: indexPath)

        let name = String(OTMStudent.ListOfStudent![indexPath.row].firstName + " " + OTMStudent.ListOfStudent![indexPath.row].lastName)
        cell.textLabel!.text = name
        cell.imageView?.image = UIImage(named: "pin")
        return cell
    }

}
