//
//  ViewController.swift
//  HitList
//
//  Created by Tom Lai on 9/13/15.
//  Copyright © 2015 Lai. All rights reserved.
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

    @IBAction func addName(sender: UIBarButtonItem) {
        let alert = UIAlertController (title: "New name", message: "Add a new name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction) -> Void in
            
            let textField = alert.textFields!.first!
            
            if let name = textField.text {
                self.names.append(name)
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in}
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        {
            let person = people[indexPath.row]
            cell.textLabel!.text = person.valueForKey("name") as! String?
            
            return cell
        }
    }

}

