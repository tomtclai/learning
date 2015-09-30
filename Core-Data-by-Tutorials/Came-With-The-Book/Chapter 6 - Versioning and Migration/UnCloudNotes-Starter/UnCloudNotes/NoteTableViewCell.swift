//
//  NoteTableViewCell.swift
//  UnCloudNotes
//
//  Created by Saul Mora on 6/15/14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import UIKit


class NoteTableViewCell: UITableViewCell
{
  var note : Note?
  {
    didSet
    {
      updateNoteInfo()
    }
  }
    
  @IBOutlet var noteTitle : UILabel!
  @IBOutlet var noteCreateDate : UILabel!
  @IBOutlet var noteImage: UIImageView!
  
  func updateNoteInfo()
  {
    if let note = note
    {
      noteTitle.text = String(note.title)
      noteCreateDate.text = note.dateCreated.description
    }
  }
  
}
