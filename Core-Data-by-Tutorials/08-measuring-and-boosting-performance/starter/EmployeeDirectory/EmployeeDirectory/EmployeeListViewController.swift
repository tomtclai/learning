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

class EmployeeListViewController: UITableViewController {

  // MARK: Properties
  var coreDataStack: CoreDataStack!

  var fetchedResultController: NSFetchedResultsController<Employee> = NSFetchedResultsController()

  var department: String?

  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    configureView()
  }

  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    guard segue.identifier == "SegueEmployeeListToDetail",
      let indexPath = tableView.indexPathForSelectedRow,
      let controller = segue.destination
        as? EmployeeDetailViewController else {
        return
    }

    let selectedEmployee =
      fetchedResultController.object(at: indexPath)
    controller.employee = selectedEmployee
  }
}

// MARK: Private
private extension EmployeeListViewController {

  func configureView() {
    fetchedResultController = employeesFetchedResultControllerFor(department)
  }
}
  
// MARK: NSFetchedResultsController
extension EmployeeListViewController {

  func employeesFetchedResultControllerFor(_ department: String?) -> NSFetchedResultsController<Employee> {

    fetchedResultController = NSFetchedResultsController(
      fetchRequest: employeeFetchRequest(department),
      managedObjectContext: coreDataStack.mainContext,
      sectionNameKeyPath: nil,
      cacheName: nil)

    fetchedResultController.delegate = self

    do {
      try fetchedResultController.performFetch()
      return fetchedResultController
    } catch let error as NSError {
      fatalError("Error: \(error.localizedDescription)")
    }
  }

  func employeeFetchRequest(_ department: String?) -> NSFetchRequest<Employee> {

    let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()

    let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]

    guard let department = department else {
      return fetchRequest
    }

    fetchRequest.predicate = NSPredicate(format: "department == %@", department)

    return fetchRequest
  }
}

// MARK: NSFetchedResultsControllerDelegate
extension EmployeeListViewController: NSFetchedResultsControllerDelegate {

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.reloadData()
  }
}

// MARK: UITableViewDataSource
extension EmployeeListViewController {

  override func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultController.sections!.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultController.sections![section].numberOfObjects
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseIdentifier = "EmployeeCellReuseIdentifier"

    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                             for: indexPath) as! EmployeeTableViewCell

    let employee = fetchedResultController.object(at: indexPath)

    cell.nameLabel.text = employee.name
    cell.departmentLabel.text = employee.department
    cell.emailLabel.text = employee.email
    cell.phoneNumberLabel.text = employee.phone
    cell.pictureImageView.image = UIImage(data: employee.picture!)

    return cell
  }
}
