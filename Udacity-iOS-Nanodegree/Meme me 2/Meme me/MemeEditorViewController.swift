//
//  MemeEditorViewController.swift
//  Meme me
//
//  Created by Tom Lai on 9/25/15.
//  Copyright © 2015 Lai. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var imageBackgroundView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    var meme : Meme?
    
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
            shareButton.enabled = true
            positionTextFields()
        }
    }
    
    var savedMeme : Meme?
    
    
    // Mark: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerView.contentMode = .ScaleAspectFit
        imageBackgroundView.contentMode = .ScaleAspectFill
        imageBackgroundView.clipsToBounds = false
        if let meme = meme {
            image = meme.originalImage
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
        }
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
        // define an instance of the ActivityViewController
        // pass the ActivityViewController a memedImage as an activity item
        let avc = UIActivityViewController(activityItems: [memedImage], applicationActivities:nil)
        avc.completionWithItemsHandler = { (activityType : String?, completed : Bool , returnedItems: Array<AnyObject>? , activityError : NSError?)in
            if completed {
                self.save(memedImage)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        // present the ActivityViewController
        presentViewController(avc, animated: true, completion: nil)
    }
    
    func save(memedImage : UIImage) {
        let meme = Meme(topText: self.topTextField.text, bottomText: self.bottomTextField.text, originalImage: self.imagePickerView.image, memedImage: memedImage)
        self.savedMeme = meme
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        pickAnImageFromSource(.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        pickAnImageFromSource(.Camera)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let anImage = info[UIImagePickerControllerOriginalImage] {
            image = anImage as? UIImage
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
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0.0
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
    
    func positionTextFields() {
        positionTopTextField()
        positionBottomTextField()
    }
    
    func positionTopTextField() {
        let newY = imagePickerView.frame.origin.y
        var newFrame = topTextField.frame
        newFrame.origin.y = newY
        topTextField.frame = newFrame
    }
    
    func positionBottomTextField() {
        let newY = imagePickerView.frame.origin.y + imagePickerView.frame.height - bottomTextField.frame.height
        var newFrame = bottomTextField.frame
        newFrame.origin.y = newY
        bottomTextField.frame = newFrame
    }
    
    // MARK: On share
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navigationController?.navigationBarHidden = true
        toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
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

