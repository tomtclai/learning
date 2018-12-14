//
//  LogInViewController.swift
//  Grocery App Firebase
//
//  Created by Hayden Goldman on 3/9/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }

    @IBAction func logInButtonDidPressed(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user :FIRUser?, error :Error?) in
            if error == nil {
                
                self.performSegue(withIdentifier: "LogInSegue", sender: self)

            } else {
                
                let alertController = UIAlertController(title: "Error!", message:
                    "Invalid email/password", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func signUpButtonDidPressed() {
        
        let alertController = UIAlertController(title: "Sign Up", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Register", style: .default, handler: {
            alert -> Void in
            
            let emailRegisterTextField = alertController.textFields![0] as UITextField
            let passwordRegisterField = alertController.textFields![1] as UITextField

            
            FIRAuth.auth()?.createUser(withEmail: emailRegisterTextField.text!, password: passwordRegisterField.text!, completion: { (user :FIRUser?, error :Error?) in
                
                if  error == nil {
                    
                    FIRAuth.auth()?.signIn(withEmail: emailRegisterTextField.text!, password: passwordRegisterField.text!, completion: { (user :FIRUser?, error :Error?) in
                        if error == nil {
                            
                            self.performSegue(withIdentifier: "LogInSegue", sender: self)
                            
                        } else {
                            
                            let alertController = UIAlertController(title: "Error!", message:
                                "Invalid email/password", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })
                } else {
                    let alertController = UIAlertController(title: "Error!", message:
                        "Invalid email/password or email is already registered", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            })

            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "email"
            
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "password"
            textField.isSecureTextEntry = true
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
