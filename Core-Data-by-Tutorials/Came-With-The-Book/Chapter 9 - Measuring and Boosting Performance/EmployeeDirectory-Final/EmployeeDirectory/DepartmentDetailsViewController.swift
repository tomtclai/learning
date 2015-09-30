/*
* Copyright (c) 2014 Razeware LLC
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

class DepartmentDetailsViewController:
  UIViewController {
  
  var coreDataStack: CoreDataStack!
  
  @IBOutlet var totalEmployeesLabel: UILabel!
  @IBOutlet var activeEmployeesLabel: UILabel!
  @IBOutlet var greaterThanFifteenVacationDaysLabel: UILabel!
  @IBOutlet var greaterThanTenVacationDaysLabel: UILabel!
  @IBOutlet var greaterThanFiveVacationDaysLabel: UILabel!
  @IBOutlet var greaterThanZeroVacationDaysLabel: UILabel!
  @IBOutlet var zeroVacationDaysLabel: UILabel!
  
  var department: String? {
    didSet {
      configureView()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  func configureView() {
    if let department = department {
      
      title = department
      
      if let label = totalEmployeesLabel {
        label.text = totalEmployees()
      }
      
      if let label = activeEmployeesLabel {
        label.text = activeEmployees()
      }
      
      if let label = greaterThanFifteenVacationDaysLabel {
        label.text = greaterThanVacationDays(15)
      }
      
      if let label = greaterThanTenVacationDaysLabel {
        label.text = greaterThanVacationDays(10)
      }
      
      if let label = greaterThanFiveVacationDaysLabel {
        label.text = greaterThanVacationDays(5)
      }
      
      if let label = greaterThanZeroVacationDaysLabel {
        label.text = greaterThanVacationDays(0)
      }
      
      if let label = zeroVacationDaysLabel {
        label.text = zeroVacationDays()
      }
    }
  }
  
  func totalEmployees() -> String {
    let fetchRequest = NSFetchRequest(entityName: "Employee")
    fetchRequest.predicate =
      NSPredicate(format: "department == %@", department!)
    
    do {
      let results = try coreDataStack.context
        .executeFetchRequest(fetchRequest)
      return String(results.count)
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      return "0"
    }
  }
  
  func activeEmployees() -> String {
    let fetchRequest = NSFetchRequest(entityName: "Employee")
    fetchRequest.predicate =
      NSPredicate(format:
        "(department == %@) AND (active == YES)", department!)
    
    do {
      let results = try coreDataStack.context
        .executeFetchRequest(fetchRequest)
      return String(results.count)
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      return "0"
    }
  }
  
  func greaterThanVacationDays(vacationDays:Int) -> String {
    let fetchRequest = NSFetchRequest(entityName: "Employee")
    fetchRequest.predicate =
      NSPredicate(format:
        "(department == %@) AND (vacationDays > %i)",
        department!, vacationDays)
    
    do {
      let results = try coreDataStack.context.executeFetchRequest(fetchRequest)
      return String(results.count)
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      return "0"
    }
  }
  
  func zeroVacationDays() -> String {
    let fetchRequest = NSFetchRequest(entityName: "Employee")
    fetchRequest.predicate =
      NSPredicate(format:
        "(department == %@) AND (vacationDays == 0)",
        department!)

    do {
      let results = try coreDataStack.context
        .executeFetchRequest(fetchRequest)
      return String(results.count)
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      return "0"
    }
  }
}
