//
//  LoginViewController.swift
//  On The Map
//
//  Created by Tom Lai on 10/8/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    let udacityDeepOrange = UIColor(red: 255/255, green: 97/255, blue: 0/255, alpha: 1.0)
    let facebookBlue = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
    let buttonRadius:CGFloat = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        themeButton(loginButton, color: udacityDeepOrange)
        themeButton(facebookLoginButton, color: facebookBlue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
    }

    @IBAction func dontHaveAnAccountTapped(sender: AnyObject) {
    }
    
    @IBAction func signInWithFacebookTapped(sender: AnyObject) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Helper functions
    func themeButton(button: UIButton, color: UIColor) {
        button.backgroundColor = color
        button.layer.cornerRadius = buttonRadius
    }

}
