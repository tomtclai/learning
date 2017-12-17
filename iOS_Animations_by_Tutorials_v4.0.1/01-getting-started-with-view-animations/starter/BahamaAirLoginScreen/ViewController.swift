/*
 * Copyright (c) 2014-present Razeware LLC
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

// A delay function
func delay(_ seconds: Double, completion: @escaping ()->Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

class ViewController: UIViewController {

  // MARK: IB outlets

  @IBOutlet var loginButton: UIButton!
  @IBOutlet var heading: UILabel!
  @IBOutlet var username: UITextField!
  @IBOutlet var password: UITextField!

  @IBOutlet var cloud1: UIImageView!
  @IBOutlet var cloud2: UIImageView!
  @IBOutlet var cloud3: UIImageView!
  @IBOutlet var cloud4: UIImageView!

  // MARK: further UI

  let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  let status = UIImageView(image: UIImage(named: "banner"))
  let label = UILabel()
  let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]

  var statusPosition = CGPoint.zero
  let spinnerOrigin = CGPoint(x: -20.0, y: 16.0)
  var loginButtonFrame = CGRect.zero
  var loginButtonColor: UIColor = UIColor.clear
  // MARK: view controller methods

  override func viewDidLoad() {
    super.viewDidLoad()

    //set up the UI
    loginButton.layer.cornerRadius = 8.0
    loginButton.layer.masksToBounds = true
    loginButtonColor = loginButton.backgroundColor!
    loginButtonFrame = loginButton.frame
    spinner.frame = CGRect(x: spinnerOrigin.x, y: spinnerOrigin.y, width: 20.0, height: 20.0)
    spinner.startAnimating()
    spinner.alpha = 0.0
    loginButton.addSubview(spinner)

    status.isHidden = true
    status.center = loginButton.center
    view.addSubview(status)

    label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
    label.font = UIFont(name: "HelveticaNeue", size: 18.0)
    label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
    label.textAlignment = .center
    status.addSubview(label)

    statusPosition = status.center
  }

  override func viewWillAppear(_ animated: Bool) {
    [username, password].forEach {$0.center.x -= view.bounds.width}
    super.viewWillAppear(animated)
    loginButton.center.y += 30.0
    loginButton.alpha = 0.0
    [cloud1, cloud2, cloud3, cloud4].forEach{ self.animateCloud(cloud: $0) }
  }

  override func viewDidAppear(_ animated: Bool) {
    // Animation objects in core animation are simply data models; you create an instance of the model and set its data properties accordingly
    let flyRight = CABasicAnimation(keyPath: "position.x")
    flyRight.fromValue = -view.bounds.size.width / 2
    flyRight.toValue = view.bounds.size.width / 2
    flyRight.duration = 0.5
    // This makes a copy of the animation object and tells Core Animation to run it on hte layer. The key is for your use only, so that you can change or stop the animation at a later time
    heading.layer.add(flyRight, forKey: nil)
    super.viewDidAppear(animated)
    let damping: CGFloat = 0.5
    let duration: TimeInterval = 0.5
    UIView.animate(withDuration: duration, delay: 0.3, usingSpringWithDamping: damping, initialSpringVelocity: 0, options:[], animations: {
      self.username.center.x += self.view.bounds.width
    })
    UIView.animate(withDuration: duration, delay: 0.4, usingSpringWithDamping: damping, initialSpringVelocity: 0, options:[], animations: {
      self.password.center.x += self.view.bounds.width
    })
    UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
      self.loginButton.center.y -= 30.0
      self.loginButton.alpha = 1.0
    }, completion: nil)
  }

  func animateCloud(cloud: UIImageView) {
    // cloud should completely cross the screen in a minute
    let parentViewWidth = view.frame.size.width
    let translation = parentViewWidth - cloud.frame.origin.x
    let speed = parentViewWidth / 60.0
    let duration : TimeInterval = TimeInterval(translation / speed)
    UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: {
      cloud.frame.origin.x = parentViewWidth
    }, completion: { _ in
      cloud.frame.origin.x = -cloud.frame.size.width
      self.animateCloud(cloud: cloud)
    })
  }
  func showMessage(index: Int) {
    label.text = messages[index]

    UIView.transition(with: status, duration: 0.33, options: [.curveEaseOut, .transitionFlipFromBottom], animations: {
      self.status.isHidden = false
    }) { _ in
      delay(2.0, completion: {
        if index < self.messages.count - 1 {
          self.removeMessage(index: index)
        } else {
          self.resetForm()
        }
      })
    }
  }

  func resetForm() {
    UIView.transition(with: status, duration: 0.2, options: [.curveEaseInOut, .transitionFlipFromTop], animations: {
      self.status.center = self.statusPosition
      self.status.isHidden = true
    }) { _ in
    }
    UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
      let size = self.spinner.frame.size
      self.spinner.frame = CGRect(x: self.spinnerOrigin.x, y: self.spinnerOrigin.y, width: size.width, height: size.height)
      self.spinner.alpha = 0.0
      self.loginButton.backgroundColor = self.loginButtonColor
      self.loginButton.frame = self.loginButtonFrame
    }) { _ in

    }
  }

  func removeMessage(index: Int) {
    UIView.animate(withDuration: 0.33, delay: 0.0, options: [], animations: {
      self.status.center.x += self.view.frame.size.width
    }, completion: { _ in
      self.status.isHidden = true
      self.status.center = self.statusPosition
      self.showMessage(index: index+1)
    })
  }

  // MARK: further methods

  @IBAction func login() {
    view.endEditing(true)
    UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options:[], animations: {
      self.loginButton.bounds.size.width += 80.0
    }, completion: { _ in
      self.showMessage(index: 0)
    })
    UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options:[], animations: {
      self.loginButton.center.y += 60.0
      self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1)
      self.spinner.center = CGPoint(x: 40.0,
                                    y: self.loginButton.frame.size.height/2)
      self.spinner.alpha = 1
    }, completion: nil)

  }

  // MARK: UITextFieldDelegate

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextField = (textField === username) ? password : username
    nextField?.becomeFirstResponder()
    return true
  }

}
