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

class CreateNoteViewController: UIViewController, UsesCoreDataObjects {

  // MARK: - Properties
  var managedObjectContext: NSManagedObjectContext?
  lazy var note: Note? = {
    guard let context = self.managedObjectContext else { return nil }
    return Note(context: context)
  }()

  // MARK: - IBOutlets
  @IBOutlet fileprivate var titleField: UITextField!
  @IBOutlet fileprivate var bodyField: UITextView!
  @IBOutlet private var attachPhotoButton: UIButton!
  @IBOutlet private var attachedPhoto: UIImageView!

  // MARK: - View Life Cycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    guard let image = note?.image else {
      titleField.becomeFirstResponder()
      return
    }
    
    attachedPhoto.image = image
    view.endEditing(true)
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let nextViewController = segue.destination as? NoteDisplayable else { return }

    nextViewController.note = note
  }
}

// MARK: - IBActions
extension CreateNoteViewController {

  @IBAction func saveNote() {
    guard let note = note,
      let managedObjectContext = managedObjectContext else {
        return
    }

    note.title = titleField.text ?? ""
    note.body = bodyField.text ?? ""

    do {
      try managedObjectContext.save()
    } catch let error as NSError {
      print("Error saving \(error)", terminator: "")
    }

    performSegue(withIdentifier: "unwindToNotesList", sender: self)
  }
}

// MARK: - UITextFieldDelegate
extension CreateNoteViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    saveNote()
    textField.resignFirstResponder()
    return false
  }
}

// MARK: - UITextViewDelegate
extension CreateNoteViewController: UITextViewDelegate {
}
