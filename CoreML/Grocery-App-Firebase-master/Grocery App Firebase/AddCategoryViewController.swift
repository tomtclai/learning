//
//  AddCategoryViewController.swift
//  Grocery App Firebase
//
//  Created by Hayden Goldman on 3/8/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

protocol AddNewCategoryDelegate {
    func addCategoryDidSave(title :String)
}

import UIKit

class AddCategoryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var categoryNameTextField: UITextField!
    var delegate: AddNewCategoryDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryNameTextField.delegate = self
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        var groceryCategory :String?
        groceryCategory = self.categoryNameTextField.text
        self.delegate.addCategoryDidSave(title: groceryCategory!)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cencelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
