//
//  AddItemViewController.swift
//  Grocery App Firebase
//
//  Created by Hayden Goldman on 3/8/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

protocol AddNewItemDelegate {
    func addItemDidSave(title :String)
}

import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var itemNameTextField: UITextField!
    var delegate :AddNewItemDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.itemNameTextField.delegate = self

    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        var groceryItem :String?
        groceryItem = self.itemNameTextField.text
        self.delegate.addItemDidSave(title: groceryItem!)
        
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
