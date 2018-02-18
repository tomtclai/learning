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
  private let filterViewControllerSegueIdentifier = "toFilterViewController"
  fileprivate let venueCellIdentifier = "VenueCell"

  var coreDataStack: CoreDataStack!
  var fetchRequest: NSFetchRequest<Venue>?
  var venues: [Venue] = []
  var asyncFetchRequest: NSAsynchronousFetchRequest<Venue>?

  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    let batchUpdate = NSBatchUpdateRequest(entityName: "Venue")
    batchUpdate.propertiesToUpdate = [#keyPath(Venue.favorite) : true]

    batchUpdate.affectedStores = coreDataStack.managedContext.persistentStoreCoordinator?.persistentStores

    batchUpdate.resultType = .updatedObjectsCountResultType

    do {
      let batchResult = try coreDataStack.managedContext.execute(batchUpdate) as! NSBatchUpdateResult
      print("Records updated \(batchResult.result!)")
    } catch let error as NSError {
      print("Could not update \(error), \(error.userInfo)")
    }

    fetchRequest = Venue.fetchRequest()
    fetchAndReload()

    // Notice here that an asynchronous fetch request doesn’t replace the regular fetch request. Rather, you can think of an asynchronous fetch request as a wrapper around the fetch request you already had.
    let venueFetchRequest: NSFetchRequest<Venue> = Venue.fetchRequest()
    fetchRequest = venueFetchRequest

    // To create an NSAsynchronousFetchRequest you need two things: a plain old NSFetchRequest and a completion handler. Your fetched venues are contained in NSAsynchronousFetchResult’s finalResult property. Within the completion handler, you update the venues property and reload the table view.
    asyncFetchRequest = NSAsynchronousFetchRequest<Venue>(fetchRequest: venueFetchRequest) { [weak self] (result: NSAsynchronousFetchResult) in
      guard let venues = result.finalResult, let strongSelf = self else {
        return
      }
      strongSelf.venues = venues
      strongSelf.tableView.reloadData()
    }

    // Specifying the completion handler is not enough! You still have to execute the asynchronous fetch request. Once again, CoreDataStack’s managedContext property handles the heavy lifting for you. However, notice the method you use is different — this time, it’s execute(_:) instead of the usual fetch(_:).
    do {
      guard let asyncFetchRequest = asyncFetchRequest else {
        return
      }
      try coreDataStack.managedContext.execute(asyncFetchRequest)
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == filterViewControllerSegueIdentifier,
      let navController = segue.destination as? UINavigationController,
      let filterVC = navController.topViewController as? FilterViewController else {
        return
    }

    filterVC.coreDataStack = coreDataStack
    filterVC.delegate = self
  }
}

// MARK: - IBActions
extension ViewController {

  @IBAction func unwindToVenueListViewController(_ segue: UIStoryboardSegue) {
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return venues.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: venueCellIdentifier, for: indexPath)
    let venue = venues[indexPath.row]
    cell.textLabel?.text = venue.name
    cell.detailTextLabel?.text = venue.priceInfo?.priceCategory
    return cell
  }
}

// MARK: - Helper methods
extension ViewController {
  func fetchAndReload() {
    guard let fetchRequest = fetchRequest else {
      return
    }

    do {
      venues = try coreDataStack.managedContext.fetch(fetchRequest)
      tableView.reloadData()
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }
}


extension ViewController: FilterViewControllerDelegate {
  func filterViewController(filter: FilterViewController, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?) {
    guard let fetchRequest = fetchRequest else {
      return
    }

    fetchRequest.predicate = nil
    fetchRequest.sortDescriptors = nil

    fetchRequest.predicate = predicate

    if let sortDescriptor = sortDescriptor {
      fetchRequest.sortDescriptors = [sortDescriptor]
    }

    fetchAndReload()
  }
}
