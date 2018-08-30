/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreData
struct KeychainConfiguration {
    static let serviceName = "TouchMeIn"
    static let accessGroup: String? = nil
}
class LoginViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext?
    var passwordItems: [KeychainPasswordItem] = []
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createInfoLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        adjustTextOnLoginButton()
    }
    func adjustTextOnLoginButton() {
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
        if hasLogin {
            loginButton.setTitle("Login", for: .normal)
            loginButton.tag = loginButtonTag
            createInfoLabel.isHidden = true
        } else {
            loginButton.setTitle("Create", for: .normal)
            loginButton.tag = createLoginButtonTag
            createInfoLabel.isHidden = false
        }
        if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
            usernameTextField.text = storedUsername
        }
    }
    // MARK: - Action for checking username/password
    func presentWrongPasswordPrompt() {
        let alertView = UIAlertController(title: "Login Problem", message: "Wrong user name or password", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Foiled again!", style: .default, handler: nil)
        alertView.addAction(okAction)
        present(alertView, animated: true, completion: nil)
    }
    @IBAction func loginAction(_ sender: AnyObject) {
        guard let userNameText = usernameTextField.text,
            let passwordText = passwordTextField.text,
            !userNameText.isEmpty,
            !passwordText.isEmpty else {
                presentWrongPasswordPrompt()
                return
        }
        if sender.tag == createLoginButtonTag {
            createAccount(id: userNameText, pw: passwordText)
        } else if sender.tag == loginButtonTag {
            login(id: userNameText, pw: passwordText)
        } else {
            print("tag not recognized!")
        }

    }

    func createAccount(id: String, pw: String) {
        if !UserDefaults.standard.bool(forKey: "hasLoginKey") {
            UserDefaults.standard.setValue(id, forKey: "username")
        }
        do {
            let passwordItem = KeychainPasswordItem(
                service: KeychainConfiguration.serviceName,
                account: id,
                accessGroup: KeychainConfiguration.accessGroup)
            try passwordItem.savePassword(pw)
        } catch {
            fatalError("Error updating keychain")
        }

        UserDefaults.standard.setValue(true, forKey: "hasLoginKey")
        loginButton.tag = loginButtonTag
        performSegue(withIdentifier: "dismissLogin", sender: self)
    }

    func login(id: String, pw: String) {
        guard checkLogin(username: usernameTextField.text!, password: passwordTextField.text!) else {
            presentWrongPasswordPrompt()
            return
        }
        self.performSegue(withIdentifier: "dismissLogin", sender: self)
    }

    func checkLogin(username: String, password: String) -> Bool {
        guard username == UserDefaults.standard.value(forKey: "username") as? String else {return false}
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
        } catch {
            fatalError("Error reading password from keychain \(error)")
        }
    }
}
