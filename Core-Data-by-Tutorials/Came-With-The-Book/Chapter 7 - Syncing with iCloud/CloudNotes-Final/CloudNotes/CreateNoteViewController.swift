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

class CreateNoteViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate
{
  var managedObjectContext : NSManagedObjectContext?
  var _note : Note?
  var note : Note
  {
  if _note == nil
  {
    _note = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: self.managedObjectContext!) as? Note
    }
    return _note!
  }
  
  @IBOutlet var titleField : UITextField!
  @IBOutlet var bodyField : UITextView!
  @IBOutlet var attachPhotoButton : UIButton!
  @IBOutlet var attachedPhoto : UIImageView!
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if let image = _note?.image {
      attachedPhoto.image = image
      view.endEditing(true)
    } else {
      titleField.becomeFirstResponder()
    }
  }

  
  @IBAction func saveNote()
  {
    note.title = titleField.text
    note.body = bodyField.text
    var error : NSErrorPointer = nil
    if managedObjectContext!.save(error) == false
    {
      print("Error saving \(error)")
    }
    performSegueWithIdentifier("unwindToNotesList", sender: self)
  }
  
  func textFieldShouldReturn(textField:UITextField) -> Bool
  {
    saveNote()
    textField.resignFirstResponder()
    return false
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if segue.identifier == "AttachPhoto" {
      let nextViewController : AttachPhotoViewController = segue.destinationViewController as! AttachPhotoViewController
      nextViewController.note = note
    }
  }
}
