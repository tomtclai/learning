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
func tintBackgroundColor(for layer: CALayer, to color: UIColor) {
  let animation = CASpringAnimation(keyPath: "backgroundColor")
  animation.fromValue = layer.backgroundColor
  animation.toValue = color.cgColor
  animation.damping = 2
  animation.stiffness = 200
  animation.duration = animation.settlingDuration
  layer.add(animation, forKey: nil)
  layer.backgroundColor = color.cgColor
}
func roundCorners(for layer: CALayer, to radius: CGFloat) {
  let animation = CASpringAnimation(keyPath: "cornerRadius")
  animation.fromValue = layer.cornerRadius
  animation.toValue = radius
  animation.damping = 2
  animation.stiffness = 200
  animation.duration = animation.settlingDuration
  layer.add(animation, forKey: nil)
  layer.cornerRadius = radius
}
class ViewController: UIViewController {

  let info = UILabel()

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

  // MARK: view controller methods

  override func viewDidLoad() {
    super.viewDidLoad()

    //set up the UI
    loginButton.layer.cornerRadius = 8.0
    loginButton.layer.masksToBounds = true
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

    info.frame = CGRect(x: 0, y: loginButton.center.y + 60, width: view.frame.size.width, height: 30)
    info.backgroundColor = .clear
    info.font = UIFont(name: "HelveticaNeue", size: 12)
    info.textAlignment = .center
    info.text = "Tap on a field and enter username and password"
    view.insertSubview(info, belowSubview: loginButton)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let cloudAnimation = CABasicAnimation(keyPath: "opacity")
    cloudAnimation.fromValue = 0
    cloudAnimation.toValue = 1
    cloudAnimation.duration = 0.5
    cloudAnimation.fillMode = kCAFillModeBackwards
    cloudAnimation.beginTime = CACurrentMediaTime() + 0.5
    cloud1.layer.add(cloudAnimation, forKey: nil)
    cloudAnimation.beginTime = CACurrentMediaTime() + 0.7
    cloud2.layer.add(cloudAnimation, forKey: nil)
    cloudAnimation.beginTime = CACurrentMediaTime() + 0.9
    cloud3.layer.add(cloudAnimation, forKey: nil)
    cloudAnimation.beginTime = CACurrentMediaTime() + 1.1
    cloud4.layer.add(cloudAnimation, forKey: nil)
  }

  override func viewDidAppear(_ animated: Bool) {
    // Animation objects in core animation are simply data models; you create an instance of the model and set its data properties accordingly
    let fadeFromPoint25 = CABasicAnimation(keyPath: "opacity")
    fadeFromPoint25.fromValue = 0.25
    fadeFromPoint25.toValue = 1.0
    let flyRight = CABasicAnimation(keyPath: "position.x")
    flyRight.fromValue = -view.bounds.size.width / 2
    flyRight.toValue = view.bounds.size.width / 2

    let formAnimation = CAAnimationGroup()
    formAnimation.delegate = self
    formAnimation.setValue("form", forKey: "name")
    formAnimation.beginTime = CACurrentMediaTime() + 0.3
    formAnimation.animations = [fadeFromPoint25, flyRight]
    formAnimation.fillMode = kCAFillModeBackwards
    formAnimation.setValue(username.layer, forKey: "layer")
    username.layer.add(formAnimation, forKey: nil)
    formAnimation.beginTime = CACurrentMediaTime() + 0.4
    formAnimation.setValue(password.layer, forKey: "layer")
    password.layer.add(formAnimation, forKey: nil)
    super.viewDidAppear(animated)

    let buttonAnimation = CAAnimationGroup()
    buttonAnimation.beginTime = CACurrentMediaTime()
    buttonAnimation.duration = 0.5
    buttonAnimation.fillMode = kCAFillModeBackwards

    let scaleDown = CABasicAnimation(keyPath: "transform.scale")
    scaleDown.fromValue = 3.5
    scaleDown.toValue = 1.0

    let rotate = CABasicAnimation(keyPath: "transform.rotation")
    rotate.fromValue = .pi / 4.0
    rotate.toValue = 0

    let fadeFromZero = CABasicAnimation(keyPath: "opacity")
    fadeFromZero.fromValue = 0.0
    fadeFromZero.toValue = 1.0

    buttonAnimation.animations = [scaleDown, rotate, fadeFromZero]

    buttonAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    loginButton.layer.add(buttonAnimation, forKey: nil)

    let flyLeft = CABasicAnimation(keyPath: "position.x")
    flyLeft.fromValue = info.layer.position.x + view.frame.size.width
    flyLeft.toValue = info.layer.position.x
    flyLeft.duration = 5.0
    
    info.layer.add(flyLeft, forKey: "infoappear")

    let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
    fadeLabelIn.fromValue = 0.2
    fadeLabelIn.toValue = 1.0
    fadeLabelIn.duration = 4.5
    info.layer.add(fadeLabelIn, forKey: "fadein")

    username.delegate = self
    password.delegate = self

    animateCloud(layer: cloud1.layer)
    animateCloud(layer: cloud2.layer)
    animateCloud(layer: cloud3.layer)
    animateCloud(layer: cloud4.layer)
  }

  func animateCloud(layer: CALayer) {
    // cloud should completely cross the screen in a minute
    let parentViewWidth = view.layer.frame.size.width
    let translation = parentViewWidth - layer.frame.origin.x
    let speed = parentViewWidth / 60.0
    let duration : TimeInterval = TimeInterval(translation / speed)

    let cloudMove = CABasicAnimation(keyPath: "position.x")
    cloudMove.duration = duration
    cloudMove.toValue = self.view.bounds.width + layer.bounds.width / 2
    cloudMove.delegate = self
    cloudMove.setValue("cloud", forKey: "name")
    cloudMove.setValue(layer, forKey: "layer")
    layer.add(cloudMove, forKey: nil)
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
      self.loginButton.frame = self.loginButtonFrame
    }) { _ in
        let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
        tintBackgroundColor(for: self.loginButton.layer, to: tintColor)
        roundCorners(for: self.loginButton.layer, to: 10)
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
      self.spinner.center = CGPoint(x: 40.0,
                                    y: self.loginButton.frame.size.height/2)
      self.spinner.alpha = 1
    }, completion: nil)
    let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1)
    tintBackgroundColor(for: loginButton.layer, to: tintColor)
    roundCorners(for: loginButton.layer, to: 25)
  }

  // MARK: UITextFieldDelegate

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextField = (textField === username) ? password : username
    nextField?.becomeFirstResponder()
    return true
  }

}
// MARK: CAAnimiationDelegate
extension ViewController: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    guard let name = anim.value(forKey: "name") as? String else {
      return
    }
    switch name {
    case "form":
      let layer = anim.value(forKey: "layer") as? CALayer
      anim.setValue(nil, forKey: "layer")

      let pulse = CASpringAnimation(keyPath: "transform.scale")
      pulse.fromValue = 1.25
      pulse.toValue = 1.0
      pulse.duration = pulse.settlingDuration
      pulse.damping = 7.5
      layer?.add(pulse, forKey: nil)
    case "cloud":
      guard let layer = anim.value(forKey: "layer") as? CALayer else {
        return
      }
      layer.position.x = -layer.bounds.width/2
      delay(0.5, completion: {
        self.animateCloud(layer: layer)
      })
    default:
      return
    }
  }
}

// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    guard let runningAnimations = info.layer.animationKeys() else {
      return
    }
    print(runningAnimations)
    info.layer.removeAnimation(forKey: "infoappear")
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text else {return}
    if text.count < 5 {
      let jump = CASpringAnimation(keyPath: "position.y")
      jump.fromValue = textField.layer.position.y + 1.0
      jump.initialVelocity = 100
      jump.mass = 10
      jump.stiffness = 1500
      jump.damping = 50
      jump.toValue = textField.layer.position.y
      jump.duration = jump.settlingDuration
      textField.layer.add(jump, forKey: nil)

      let flash = CASpringAnimation(keyPath: "borderColor")
      flash.damping = 7
      flash.stiffness = 200
      flash.fromValue = UIColor(red: 1.0, green: 0.27, blue: 0, alpha: 1).cgColor
      flash.toValue = UIColor.white.cgColor
      flash.duration = flash.settlingDuration
      textField.layer.borderWidth = 2
      textField.layer.cornerRadius = 5
      textField.layer.borderColor = UIColor.white.cgColor
      textField.layer.add(flash, forKey: nil)
    }
  }
}
