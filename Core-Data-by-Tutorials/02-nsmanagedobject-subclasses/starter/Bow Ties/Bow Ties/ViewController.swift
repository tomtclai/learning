/*
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
class ViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var timesWornLabel: UILabel!
  @IBOutlet weak var lastWornLabel: UILabel!
  @IBOutlet weak var favoriteLabel: UILabel!

  // MARK: - Properties
  var managedContext: NSManagedObjectContext!
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    insertSampleDataIfNeeded()

    let request : NSFetchRequest<Bowtie> = Bowtie.fetchRequest()
    // The predicate is looking for bowties with their searchKey set to segment control's first button title, 'R'
    let firstTitle = segmentedControl.titleForSegment(at: 0)!
    request.predicate = NSPredicate(
      format: "%K = %@",
      argumentArray: [#keyPath(Bowtie.searchKey), firstTitle])
    do {
      // The managed object context executes the fetch requestion you crafted above and returns an array of Bowties
      let results = try managedContext.fetch(request)

      // Populate the UI with the first bowtie in the results array
      populate(bowtie: results.first!)
    } catch let error as NSError {
      print("COuld not fetch \(error), \(error.userInfo)")
    }
  }

  // MARK: - IBActions
  @IBAction func segmentedControl(_ sender: Any) {

  }

  @IBAction func wear(_ sender: Any) {

  }
  
  @IBAction func rate(_ sender: Any) {

  }

  func populate(bowtie: Bowtie) {
    guard let imageData = bowtie.photoData as Data?,
      let lastWorn = bowtie.lastWorn as Date?,
      let tintColor = bowtie.tintColor as? UIColor else {
        return
    }

    imageView.image = UIImage(data: imageData)
    nameLabel.text = bowtie.name
    ratingLabel.text = "Rating: \(bowtie.rating)/5"

    timesWornLabel.text = "# times worn: \(bowtie.timesWorn)"

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none

    lastWornLabel.text = "Last worn: " + dateFormatter.string(from: lastWorn)

    favoriteLabel.isHidden = !bowtie.isFavorite
    view.tintColor = tintColor
  }

  func insertSampleDataIfNeeded() {
    let fetch: NSFetchRequest<Bowtie> = Bowtie.fetchRequest()
    fetch.predicate = NSPredicate(format: "searchKey != nil")

    guard try! managedContext.count(for: fetch) == 0 else {
      return
    }

    let path = Bundle.main.path(forResource: "SampleData", ofType: "plist")
    let dataArray = NSArray(contentsOfFile: path!)!

    for dict in dataArray {
      let entity = NSEntityDescription.entity(forEntityName: "Bowtie", in: managedContext)!
      let bowtie = Bowtie(entity: entity, insertInto: managedContext)
      let btDict = dict as! [String: Any]

      bowtie.id = UUID(uuidString: btDict["id"] as! String)
      bowtie.name = btDict["name"] as? String
      bowtie.searchKey = btDict["searchKey"] as? String
      bowtie.rating = btDict["rating"] as! Double
      let colorDict = btDict["tintColor"] as! [String: Any]
      bowtie.tintColor = UIColor.color(dict: colorDict)

      let imageName = btDict["imageName"] as? String
      let image = UIImage(named: imageName!)
      let photoData = UIImagePNGRepresentation(image!)!
      bowtie.photoData = NSData(data: photoData)
      bowtie.lastWorn = btDict["lastWorn"] as? NSDate

      let timesNumber = btDict["timesWorn"] as! NSNumber
      bowtie.timesWorn = timesNumber.int32Value
      bowtie.isFavorite = btDict["isFavorite"] as! Bool
      bowtie.url = URL(string: btDict["url"] as! String)
    }
    try! managedContext.save()
  }
}

private extension UIColor {
  static func color(dict: [String: Any]) -> UIColor? {
    guard let red = dict["red"] as? NSNumber,
      let green = dict["green"] as? NSNumber,
      let blue = dict["blue"] as? NSNumber else {
        return nil
    }

    return UIColor(red: CGFloat(truncating: red) / 255.0,
                   green: CGFloat(truncating: green) / 255.0,
                   blue: CGFloat(truncating: blue) / 255.0,
                   alpha: 1)
  }
}
