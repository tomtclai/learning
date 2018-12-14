//
//  ItemTableViewController.swift
//  Grocery App Firebase
//
//  Created by Hayden Goldman on 3/8/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ItemTableViewController: UITableViewController, AddNewItemDelegate {
    
    var categories = Category()
    var items = [Item]()
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    var item = Item()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.categories.title
        
        self.populateData()
        
    }
    
    private func populateData() {
        
        let ref = FIRDatabase.database().reference(withPath: self.userID!)
        ref.observe(.value) { (snapshot :FIRDataSnapshot) in
            
            self.items.removeAll()
            
            for snap in snapshot.children {
                
                let snapshotDictionary = (snap as! FIRDataSnapshot).value as! [String:Any]
                
                if snapshotDictionary["title"] as? String == self.categories.title {
                    
                    
                    let itemArrayOfDictionaries = snapshotDictionary["items"] as? [[String:Any]]
                    
                    if itemArrayOfDictionaries == nil {
                        
                    } else {
                        
                    for items in itemArrayOfDictionaries! {
                        
                        let itemDictionary = items
                        let itemTitles = itemDictionary["title"] as? String
                        
                        let item = Item()
                        item.title = itemTitles!
                        
                        self.items.append(item)
                    }
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func addData(title :String) {
        let ref = FIRDatabase.database().reference(withPath: self.userID!)
        let categoryRef = ref.child(self.categories.title!)
        
        let item = Item()
        item.title = title
        
        self.items.append(item)
        
        self.categories.items = self.items
        
        categoryRef.setValue(self.categories.toDictionary())
    }
    
    private func updateData() {
        let ref = FIRDatabase.database().reference(withPath: self.userID!)
        let categoryRef = ref.child(self.categories.title!)
        
        self.categories.items = self.items

        categoryRef.setValue(self.categories.toDictionary())
        
    }

    //add item
    func addItemDidSave(title :String) {
        
        self.addData(title: title)
        self.populateData()
    }
    
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItem" {
            let addItemVC: AddItemViewController = segue.destination as! AddItemViewController
            addItemVC.delegate = self
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let item = self.items[indexPath.row]
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            self.items.remove(at: indexPath.row)
            
            self.tableView.reloadData()
            
            self.updateData()
            
        }
    }



}
