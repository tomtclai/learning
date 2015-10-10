//
//  LoginViewController.swift
//  On The Map
//
//  Created by Tom Lai on 10/8/15.
//  Copyright © 2015 Tom Lai. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let udacityDeepOrange = UIColor(red: 255/255, green: 97/255, blue: 0/255, alpha: 1.0)
    let facebookBlue = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
    let transparent = UIColor.clearColor()
    let buttonRadius:CGFloat = 4.0
    
    var session: NSURLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
        
        /* Configure UI */
        configureUI()
    }

    override func viewWillAppear(animated: Bool) {
        loginButton.titleLabel?.text = "Login"
    }
    
    override func viewDidAppear(animated: Bool) {
        emailField.text = ""
        passwordField.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        let username = emailField.text
        let password = passwordField.text
        guard (username != nil && password != nil &&
               !username!.isEmpty && !password!.isEmpty) else {
                print("Login button tapped but username/password empty")
                shakeView(loginButton)
            return
        }
        UdacityClient.sharedInstance().postSessionWithUsername(username!, password: password!) { (sessionID, accountID, error) -> Void in
            if let error = error {
                print(error)
                self.shakeView(self.loginButton)
            }
            UdacityClient.sharedInstance().sessionID = sessionID
            UdacityClient.sharedInstance().userAccount = accountID
            print("session \(sessionID) account \(accountID)")
            if let loggedInVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController")
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.presentViewController(loggedInVC, animated: true, completion: nil)
                })
            } else {
                print("viewcontroller with identifier \"TabBarController\" not found in IB")
            }
        }
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
    func configureUI() {
        themeButton(loginButton, color: udacityDeepOrange)
        themeButton(facebookLoginButton, color: facebookBlue)
        themeButton(signUpButton, color: transparent)
        themeTextField(emailField)
        themeTextField(passwordField)
        

    }
    
    func themeButton(button: UIButton, color: UIColor) {
        button.backgroundColor = color
        button.layer.cornerRadius = buttonRadius
        
        let font = UIFont(name: "Roboto-Regular", size: 17.0)
        button.titleLabel?.font = font
    }
    
    func themeTextField(field: UITextField) {
        let placeholder = field.placeholder!
        field.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        let font = UIFont(name: "Roboto-Regular", size: 17.0)
        field.font = font
    }

    func shakeView(view: UIView) {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(view.center.x - 10, view.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(view.center.x + 10, view.center.y))
        view.layer.addAnimation(animation, forKey: "position")
    }
    

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        if textField == passwordField {
            passwordField.resignFirstResponder()
            loginButtonTapped(self)
        }
        return true
    }
    @IBAction func userDidTap(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            passwordField.resignFirstResponder()
            emailField.resignFirstResponder()
        }
    }
}
