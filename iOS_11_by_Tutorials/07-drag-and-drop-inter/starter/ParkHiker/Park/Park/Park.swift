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
import CoreLocation

enum EncodingError: Error {
  case invalidData
}

open class Park: NSObject, NSCoding {
  
  public enum Key {
    public static let image = "image"
    public static let name = "name"
    public static let summary = "summary"
    public static let longitude = "longitude"
    public static let latitude = "latitude"
  }
  
  public var image: UIImage
  public let name: String
  public let summary: String
  public let longitude: Double
  public let latitude: Double
  
  public init(image: UIImage, name: String, summary: String, longitude: Double, latitude: Double) {
    self.image = image
    self.name = name
    self.summary = summary
    self.longitude = longitude
    self.latitude = latitude
    super.init()
  }
  
  public required init(_ park: Park) {
    self.image = park.image
    self.name = park.name
    self.summary = park.summary
    self.longitude = park.longitude
    self.latitude = park.latitude
    super.init()
  }
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(UIImagePNGRepresentation(image), forKey: Key.image)
    aCoder.encode(name, forKey: Key.name)
    aCoder.encode(summary, forKey: Key.summary)
    aCoder.encode(longitude, forKey: Key.longitude)
    aCoder.encode(latitude, forKey: Key.latitude)
  }
  
  public required convenience init?(coder aDecoder: NSCoder) {
    guard let image = (aDecoder.decodeObject(forKey: Key.image) as? Data).flatMap(UIImage.init),
    let name = aDecoder.decodeObject(forKey: Key.name) as? String,
    let summary = aDecoder.decodeObject(forKey: Key.summary) as? String
      else { return nil }
    let longitude = aDecoder.decodeDouble(forKey: Key.longitude)
    let latitude = aDecoder.decodeDouble(forKey: Key.latitude)
    
    self.init(image: image, name: name, summary: summary, longitude: longitude, latitude: latitude)
  }
}

