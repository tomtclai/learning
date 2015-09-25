//
//  ViewController.swift
//  Meme me
//
//  Created by Tom Lai on 9/25/15.
//  Copyright © 2015 Lai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var imageBackgroundView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let memeTextArrtibutes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(int: -5)
    ]
    
    var image : UIImage? {
        get {
            return self.image
        }
        set(image) {
            imagePickerView.image = image
            imageBackgroundView.image = imagePickerView.image
            currentMeme.originalImage = image
            shareButton.enabled = true
        }
    }
    
    var currentMeme = Meme()
    
    
    // Mark: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerView.contentMode = .ScaleAspectFit
        imageBackgroundView.contentMode = .ScaleAspectFill
        imageBackgroundView.clipsToBounds = false
        setUpMemeTextFields()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        libraryButton.enabled = UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
        topTextField.delegate = self
        bottomTextField.delegate = self
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    // Mark: - IB Actions
    
    @IBAction func share(sender: AnyObject) {
        // generate a memed image
        let memedImage = generateMemedImage()
        currentMeme.memedImage = memedImage
        // define an instance of the ActivityViewController
        // pass the ActivityViewController a memedImage as an activity item
        let avc = UIActivityViewController(activityItems: [memedImage], applicationActivities:nil)
        // present the ActivityViewController
        presentViewController(avc, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        pickAnImageFromSource(.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        pickAnImageFromSource(.Camera)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] {
            self.image = image as? UIImage
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Helpers
    
    // MARK: Keyboard notifications
    
    func keyboardWillShow(notification: NSNotification) {
        if (bottomTextField.isFirstResponder()) {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        return (notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.height)!
    }
    
    func subscribeToKeyboardNotifications() {
        subscribeSelfTo(UIKeyboardWillShowNotification, selector: "keyboardWillShow:")
        subscribeSelfTo(UIKeyboardWillHideNotification, selector: "keyboardWillHide:")
    }
    
    func subscribeSelfTo(name : String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        unsubscribeSelfFrom(UIKeyboardWillHideNotification)
        unsubscribeSelfFrom(UIKeyboardWillShowNotification)
    }
    
    func unsubscribeSelfFrom(name: String) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: name, object: nil)
    }
    
    // MARK: Image Picker
    func pickAnImageFromSource(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: On view load
    func styleTextField(textField: UITextField) {
        textField.defaultTextAttributes = memeTextArrtibutes
        textField.textAlignment = .Center
    }
    
    func setUpMemeTextFields() {
        styleTextField(topTextField)
        styleTextField(bottomTextField)
        
        topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: memeTextArrtibutes)
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: memeTextArrtibutes)
        
    }
    
    // MARK: On share
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navigationController?.navigationBarHidden = true
        toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navigationController?.navigationBarHidden = false
        toolbar.hidden = false
        return memedImage
    }
    
}

