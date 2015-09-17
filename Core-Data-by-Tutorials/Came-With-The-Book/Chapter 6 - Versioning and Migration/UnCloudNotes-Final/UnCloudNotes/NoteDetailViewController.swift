//
//  NoteDetailViewController.swift
//  UnCloudNotes
//
//  Created by Saul Mora on 6/15/14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController
{
  var note : Note? {
    didSet {
      updateNoteInfo()
    }
  }
    
  @IBOutlet var titleField : UILabel!
  @IBOutlet var bodyField : UITextView!
    
  func updateNoteInfo() {
    if isViewLoaded(), let note = note
    {
      titleField.text = String(note.title)
      bodyField.text = String(note.body)
    }
  }
    
  override func viewWillAppear(animated: Bool) {
    updateNoteInfo()
  }
  
}
