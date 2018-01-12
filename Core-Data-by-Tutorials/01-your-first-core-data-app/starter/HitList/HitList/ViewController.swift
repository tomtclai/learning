//
//  ViewController.swift
//  HitList
//
//  Created by Tom Lai on 1/11/18.
//  Copyright © 2018 Lai. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  var people: [NSManagedObject] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "The List"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.dataSource = self
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewWillAppear(_ animated: Bool) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    // before you do anything with core data you need a context
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
    do {
      people = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  @IBAction func addName(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
    let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
      guard let textField = alert.textFields?.first,
        let name = textField.text,
        let strongSelf = self else {
        return
      }
      strongSelf.save(name: name)
      strongSelf.tableView.reloadData()

    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .default)
    alert.addTextField()
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    present(alert, animated: true)
  }

  func save(name: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    // You can consider a managed object context as an in memory scratchpad for working with managed objects
    let managedContext = appDelegate.persistentContainer.viewContext

    // You create a new managed object and inserted it into the context.
    let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!

    let person = NSManagedObject(entity: entity, insertInto: managedContext)

    // You must spell KCV key exactly otherwise the app will crash at runtime
     person.setValue(name, forKey: "name")

    do {
      try managedContext.save()
      people.append(person)
    } catch let error as NSError {
      print("Could not save \(error), \(error.userInfo)")
    }
  }
}
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = people[indexPath.row].value(forKeyPath: "name") as? String
    return cell
  }
}
