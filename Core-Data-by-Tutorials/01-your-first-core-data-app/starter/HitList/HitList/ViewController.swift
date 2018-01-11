//
//  ViewController.swift
//  HitList
//
//  Created by Tom Lai on 1/11/18.
//  Copyright © 2018 Lai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  var names: [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "The List"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func addName(_ sender: UIBarButtonItem) {

  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return names.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = names[indexPath.row]
    return cell
  }
}
