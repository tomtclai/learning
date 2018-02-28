/**
 * Copyright (c) 2017 Razeware LLC
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
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
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

class ViewController: UIViewController {

  // MARK: - Properties
  fileprivate let teamCellIdentifier = "teamCellReuseIdentifier"
  var coreDataStack: CoreDataStack!

  lazy var fetchedResultsController: NSFetchedResultsController<Team> = {
    //  Like NSFetchRequest, NSFetchedResultsController requires a generic type paremeter, Team in this case, to specify the type of entity you expect to be working with. Let’s go step by step through the process:
    //  The fetched results controller handles the coordination between Core Data and your table view, but it still needs you to provide an NSFetchRequest. Remember the NSFetchRequest class is highly customizable. It can take sort descriptors, predicates, etc.
  //  In this example, you get your NSFetchRequest directly from the Team class because you want to fetch all Team objects.
    let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
    //    A regular fetch request doesn’t require a sort descriptor. Its minimum requirement is you set an entity description, and it will fetch all objects of that entity type. NSFetchedResultsController, however, requires at least one sort descriptor. Otherwise, how would it know the right order for your table view?
    let zoneSort = NSSortDescriptor(key: #keyPath(Team.qualifyingZone), ascending: true)
    let scoreSort = NSSortDescriptor(key: #keyPath(Team.wins), ascending: false)
    let nameSort = NSSortDescriptor(key: #keyPath(Team.teamName), ascending: true)
    fetchRequest.sortDescriptors = [zoneSort, scoreSort, nameSort]
  //   The initializer method for a fetched results controller takes four parameters: first is the fetch request you just created.
  //   The second parameter is an instance of NSManagedObjectContext. Like NSFetchRequest, the fetched results controller class needs a managed object context to execute the fetch. It can’t actually fetch anything by itself.
  //   The other two parameters are optional: sectionNameKeyPath and cacheName. Leave them blank for now; you’ll read more about them later in the chapter.”

    // You specify a cacheName to turnon NSFetechedResultsController's on-dish section cache. That's all you need to do! Keep in your that this section cache is completely separate from CoreData's persistent store, where you persist the teams.
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: #keyPath(Team.qualifyingZone), cacheName: "worldCup")
    return fetchedResultsController
  }()


  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var addButton: UIBarButtonItem!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchedResultsController.delegate = self
    do {
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      print("Fetching error: \(error), \(error.userInfo)")
    }
  }

  override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      addButton.isEnabled = true
    }
  }
}

// MARK: - Internal
extension ViewController {

  func configure(cell: UITableViewCell, for indexPath: IndexPath) {

    guard let cell = cell as? TeamCell else {
      return
    }


    let team = fetchedResultsController.object(at: indexPath)
    cell.teamLabel.text = team.teamName
    cell.scoreLabel.text = "Wins: \(team.wins)"

    if let imageName = team.imageName {
      cell.flagImageView.image = UIImage(named: imageName)
    } else {
      cell.flagImageView.image = nil
    }
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    guard let sections = fetchedResultsController.sections else {
      return 0
    }
    return sections.count
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let section = fetchedResultsController.sections?[section]
    return section?.name
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = fetchedResultsController.sections?[section] else {
      return 0
    }
    return section.numberOfObjects
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: teamCellIdentifier, for: indexPath)
    configure(cell: cell, for: indexPath)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let team = fetchedResultsController.object(at: indexPath)
    team.wins = team.wins + 1
    coreDataStack.saveContext()

  }
}


extension ViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
    case .update:
      let cell = tableView.cellForRow(at: indexPath!) as! TeamCell
      configure(cell: cell, for: indexPath!)
    case .move:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    }
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
}

// MARK: - IBActions
extension ViewController {
  @IBAction func addTeam(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Secret Team", message: "Add a new team", preferredStyle: .alert)
    alert.addTextField { textfield in
      textfield.placeholder = "Team Name"
    }

    alert.addTextField { textfield in
      textfield.placeholder = "Qualifying Zone"
    }

    let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
      guard let strongSelf = self,
        let nameTextField = alert.textFields?.first,
        let zoneTextField = alert.textFields?.last else {
          return
      }
      let team = Team(context: strongSelf.coreDataStack.managedContext)

      team.teamName = nameTextField.text
      team.qualifyingZone = zoneTextField.text
      team.imageName = "wenderland-flag"
      strongSelf.coreDataStack.saveContext()
    }

    alert.addAction(saveAction)
    alert.addAction(UIAlertAction(title: "Cancel", style: .default))

    present(alert, animated: true)
  }
}
