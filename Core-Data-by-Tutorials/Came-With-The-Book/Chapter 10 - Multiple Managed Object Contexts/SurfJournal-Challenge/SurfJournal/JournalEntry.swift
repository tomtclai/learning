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

import Foundation
import CoreData

class JournalEntry: NSManagedObject {

  @NSManaged var date: NSDate?
  @NSManaged var height: String?
  @NSManaged var period: String?
  @NSManaged var wind: String?
  @NSManaged var location: String?
  @NSManaged var rating: NSNumber?
  
  func stringForDate() -> String {
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    if let date = date {
      return dateFormatter.stringFromDate(date)
    } else {
      return ""
    }
  }
  
  func csv() -> String {
    
    let coalescedHeight = height ?? ""
    let coalescedPeriod = period ?? ""
    let coalescedWind = wind ?? ""
    let coalescedLocation = location ?? ""
    var coalescedRating:String
    if let rating = rating?.intValue {
      coalescedRating = String(rating)
    } else {
      coalescedRating = ""
    }
    
    return "\(stringForDate()),\(coalescedHeight)," +
      "\(coalescedPeriod),\(coalescedWind)," +
        "\(coalescedLocation),\(coalescedRating)\n"
  }
}
