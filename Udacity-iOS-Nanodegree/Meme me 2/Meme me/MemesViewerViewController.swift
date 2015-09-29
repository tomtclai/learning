//
//  MemesViewerViewController.swift
//  Meme me 2
//
//  Created by Tom Lai on 9/28/15.
//  Copyright © 2015 Lai. All rights reserved.
//

import UIKit

class MemesViewerViewController: UIViewController {
    var memeIndex : Int?
    
    @IBOutlet private weak var imageView: UIImageView!
    private var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    private var image: UIImage?
    
    
    override func viewDidLoad() {
        imageView.contentMode = .ScaleAspectFit
        if let memeIndex = memeIndex {
            image = appDelegate.memes[memeIndex]?.memedImage
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.hidesBarsOnTap = true
        if let image = image  {
            imageView.image = image
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }

    @IBAction func remove(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure you want to delete this meme?", message: "This action is irreversible", preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "Delete", style: .Destructive) { (UIAlertAction) -> Void in
            self.appDelegate.removeMemeAtIndex(self.memeIndex!)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MemeEditorViewController" {
            if let dvc = segue.destinationViewController as? UINavigationController {
                if let mevc = dvc.viewControllers.first as? MemeEditorViewController {
                    mevc.memeIndex = memeIndex
                }
            }
        }
    }
}
