//
//  AttachPhotoViewController.swift
//  UnCloudNotes
//
//  Created by Richard Turton on 26/07/2014.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import UIKit

class AttachPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var note : Note?
  
  lazy var imagePicker : UIImagePickerController = {
    let picker = UIImagePickerController()
    picker.sourceType = .PhotoLibrary
    picker.delegate = self
    self.addChildViewController(picker)
    return picker
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(imagePicker.view)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    imagePicker.view.frame = view.bounds
  }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    if let note = note {
      note.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    self.navigationController?.popViewControllerAnimated(true)
  }

}
