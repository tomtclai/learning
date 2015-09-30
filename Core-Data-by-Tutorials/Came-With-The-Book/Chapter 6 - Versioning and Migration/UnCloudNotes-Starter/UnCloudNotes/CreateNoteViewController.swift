//
//  CreateNoteViewController.swift
//  UnCloudNotes
//
//  Created by Saul Mora on 6/11/14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import UIKit
import CoreData

class CreateNoteViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate
{
  var managedObjectContext : NSManagedObjectContext?
  lazy var note: Note? =
  {
    if let context = self.managedObjectContext
    {
      return NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: context) as? Note
    }
    return .None
  }()
  
  @IBOutlet var titleField : UITextField!
  @IBOutlet var bodyField : UITextView!
  @IBOutlet var attachPhotoButton : UIButton!
  @IBOutlet var attachedPhoto : UIImageView!
  
  override func viewDidAppear(animated: Bool)
  {
    super.viewDidAppear(animated)
    titleField.becomeFirstResponder()
  }
  
  @IBAction func saveNote()
  {
    note?.title = titleField.text
    note?.body = bodyField.text
    
    if let managedObjectContext = managedObjectContext {
      do {
        try  managedObjectContext.save()
      }
      catch let error as NSError {
        print("Error saving \(error)", terminator: "")
      }
    }
    performSegueWithIdentifier("unwindToNotesList", sender: self)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool
  {
    saveNote()
    textField.resignFirstResponder()
    return false
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if segue.identifier == "AttachPhoto" {
      if let nextViewController = segue.destinationViewController as? AttachPhotoViewController {
        nextViewController.note = note
      }
    }
  }
}
