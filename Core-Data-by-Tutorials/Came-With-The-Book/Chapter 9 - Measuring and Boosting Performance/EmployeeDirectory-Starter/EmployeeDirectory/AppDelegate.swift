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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  lazy var coreDataStack = CoreDataStack()

  let amountToImport = 50
  let addSalesRecords = true
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
    [NSObject : AnyObject]?) -> Bool {
   
    importJSONSeedDataIfNeeded()
      
    let tabController = window!.rootViewController
      as! UITabBarController
    let employeeListNavigationController =
      tabController.viewControllers![0]
        as! UINavigationController
    let employeeListViewController =
      employeeListNavigationController.topViewController
        as! EmployeeListViewController
    employeeListViewController.coreDataStack = coreDataStack
      
    let departmentListNavigationController =
      tabController.viewControllers![1]
       as! UINavigationController
    let departmentListViewController =
      departmentListNavigationController.topViewController
        as! DepartmentListViewController
    departmentListViewController.coreDataStack = coreDataStack

    return true
  }
  
  func applicationWillTerminate(application: UIApplication) {
    coreDataStack.saveContext()
  }
  
  
  //MARK: Data Import
  
  func importJSONSeedDataIfNeeded() {
    var importRequired = false

    let fetchRequest = NSFetchRequest(entityName: "Employee")
    var error: NSError? = nil
    let employeeCount =
      coreDataStack.context.countForFetchRequest(fetchRequest,
        error: &error)
    
    if employeeCount != amountToImport {
      importRequired = true
    }

    if !importRequired && addSalesRecords {
      let salesFetch = NSFetchRequest(entityName: "Sale")
      var salesError : NSError? = nil
      let salesCount =
        coreDataStack.context.countForFetchRequest(salesFetch,
          error: &salesError)
      if salesCount == 0 {
        importRequired = true
      }
    }

    if importRequired {
      
      let deleteRequest =
        NSBatchDeleteRequest(fetchRequest: fetchRequest)
      deleteRequest.resultType = .ResultTypeCount
      
      let deletedObjectCount: Int
      do {
        let resultBox = try coreDataStack.context
          .executeRequest(deleteRequest)
            as! NSBatchDeleteResult
        deletedObjectCount = resultBox.result as! Int
      } catch {
        let nserror = error as NSError
        print("Error: \(nserror.localizedDescription)")
        abort()
      }
      
      print("Removed \(deletedObjectCount) objects.")
      coreDataStack.saveContext()
      let records = max(0, min(500, amountToImport))
      importJSONSeedData(records)
    }
  }
  
  func importJSONSeedData(records: Int) {
    
    let jsonURL = NSBundle.mainBundle().URLForResource("seed",
      withExtension: "json")!
    let jsonData = NSData(contentsOfURL: jsonURL)!
    
    var jsonArray = NSArray()
    do {
      jsonArray = try NSJSONSerialization
        .JSONObjectWithData(jsonData, options: []) as! NSArray
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
      abort()
    }
    
    let entity =
      NSEntityDescription.entityForName("Employee",
        inManagedObjectContext: coreDataStack.context)!
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    var counter = 0
    for jsonDictionary in jsonArray {
      
      counter++
      
      let guid = jsonDictionary.valueForKey("guid") as! String
      let active = jsonDictionary.valueForKey("active") as! Bool
      let name = jsonDictionary.valueForKey("name") as! String
      let vacationDays =
        jsonDictionary.valueForKey("vacationDays") as! Int
      let department =
        jsonDictionary.valueForKey("department") as! String
      let startDate =
        jsonDictionary.valueForKey("startDate") as! String
      let email = jsonDictionary.valueForKey("email") as! String
      let phone = jsonDictionary.valueForKey("phone") as! String
      let address =
        jsonDictionary.valueForKey("address") as! String
      let about =
        jsonDictionary.valueForKey("about") as! String
      let picture =
        jsonDictionary.valueForKey("picture") as! String
      let pictureComponents =
        picture.componentsSeparatedByString(".")
      let pictureFileName = pictureComponents[0] as String
      let pictureFileExtension = pictureComponents[1] as String
      let pictureURL =
        NSBundle.mainBundle().URLForResource(pictureFileName,
          withExtension: pictureFileExtension)!
      let pictureData = NSData(contentsOfURL: pictureURL)!
      
      let employee = Employee(entity: entity,
        insertIntoManagedObjectContext: coreDataStack.context)
      employee.guid = guid
      employee.active = NSNumber(bool: active)
      employee.name = name
      employee.vacationDays = NSNumber(integer: vacationDays)
      employee.department = department
      employee.startDate =
        dateFormatter.dateFromString(startDate)!
      employee.email = email
      employee.phone = phone
      employee.address = address
      employee.about = about
      employee.picture = pictureData
      
      if addSalesRecords {
        addSalesRecordsToEmployee(employee)
      }
      
      if counter == records {
        break
      }
      
      if counter % 20 == 0 {
        coreDataStack.saveContext()
        coreDataStack.context.reset()
      }
    }
    
    coreDataStack.saveContext()
    coreDataStack.context.reset()
    print("Imported \(counter) employees.")
  }
  
  func imageDataScaledToHeight(imageData: NSData,
    height: CGFloat) -> NSData {
      
      let image = UIImage(data: imageData)!
      let oldHeight = image.size.height
      let scaleFactor = height / oldHeight
      let newWidth = image.size.width * scaleFactor
      let newSize = CGSizeMake(newWidth, height)
      let newRect = CGRectMake(0, 0, newWidth, height)
      
      UIGraphicsBeginImageContext(newSize)
      image.drawInRect(newRect)
      let newImage =
        UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      return UIImageJPEGRepresentation(newImage, 0.8)!
  }
  
  func addSalesRecordsToEmployee(employee:Employee) {
    let numberOfSales = 1000 + arc4random_uniform(5000)
    for _ in 0...numberOfSales {
      let sale =
        NSEntityDescription.insertNewObjectForEntityForName(
         "Sale", inManagedObjectContext: coreDataStack.context)
           as! Sale
      sale.employee = employee
      sale.amount = NSNumber(unsignedInt:3000 + arc4random_uniform(20000))
    }
    print("added \(employee.sales.count) sales")
  }

}

