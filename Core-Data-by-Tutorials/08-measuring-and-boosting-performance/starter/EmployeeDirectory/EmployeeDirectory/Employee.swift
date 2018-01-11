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

import Foundation
import CoreData

public class Employee: NSManagedObject {

}

extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var about: String?
    @NSManaged public var active: NSNumber?
    @NSManaged public var address: String?
    @NSManaged public var department: String?
    @NSManaged public var email: String?
    @NSManaged public var guid: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var picture: Data?
    @NSManaged public var startDate: Date?
    @NSManaged public var vacationDays: NSNumber?
    @NSManaged public var sales: NSSet?

}

// MARK: Generated accessors for sales
extension Employee {

    @objc(addSalesObject:)
    @NSManaged public func addToSales(_ value: Sale)

    @objc(removeSalesObject:)
    @NSManaged public func removeFromSales(_ value: Sale)

    @objc(addSales:)
    @NSManaged public func addToSales(_ values: NSSet)

    @objc(removeSales:)
    @NSManaged public func removeFromSales(_ values: NSSet)

}
