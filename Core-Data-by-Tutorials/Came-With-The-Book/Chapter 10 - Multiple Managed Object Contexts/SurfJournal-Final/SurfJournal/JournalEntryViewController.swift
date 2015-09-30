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

protocol JournalEntryDelegate {
  
  func didFinishViewController(
    viewController:JournalEntryViewController, didSave:Bool)
  
}

class JournalEntryViewController: UITableViewController {
    
  @IBOutlet weak var heightTextField: UITextField!
  @IBOutlet weak var periodTextField: UITextField!
  @IBOutlet weak var windTextField: UITextField!
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var ratingSegmentedControl:
    UISegmentedControl!
    
  var journalEntry: JournalEntry! {
    didSet {
      self.configureView()
    }
  }
    
  var context: NSManagedObjectContext!
  var delegate:JournalEntryDelegate?

  
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureView()
  }
  
  
  // MARK: View Setup
  
  func configureView() {
    
    title = journalEntry.stringForDate()
    
    if let textField = heightTextField {
      if let value = journalEntry.height {
        textField.text = value
      }
    }
    
    if let textField = periodTextField {
      if let value = journalEntry.period {
        textField.text = value
      }
    }
    
    if let textField = windTextField {
      if let value = journalEntry.wind {
        textField.text = value
      }
    }
    
    if let textField = locationTextField {
      if let value = journalEntry.location {
        textField.text = value
      }
    }
    
    if let segmentControl = ratingSegmentedControl {
      if let rating = journalEntry.rating {
        segmentControl.selectedSegmentIndex =
          rating.integerValue - 1
      }
    }
    
  }
  
  func updateJournalEntry() {
    
    if let entry = journalEntry {
      entry.date = NSDate()
      entry.height = heightTextField.text
      entry.period = periodTextField.text
      entry.wind = windTextField.text
      entry.location = locationTextField.text
      entry.rating =
        NSNumber(integer:
          ratingSegmentedControl.selectedSegmentIndex + 1)
    }
  }
  
  
  // MARK: Target Action
  
  @IBAction func cancelButtonWasTapped(sender: AnyObject) {
    delegate?.didFinishViewController(self, didSave: false)
  }
  
  @IBAction func saveButtonWasTapped(sender: AnyObject) {
    updateJournalEntry()
    delegate?.didFinishViewController(self, didSave: true)
  }
  
}

