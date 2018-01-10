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
import QuartzCore

class ContainerViewController: UIViewController {
  
  let menuWidth: CGFloat = 80.0
  let animationTime: TimeInterval = 0.5
  
  let menuViewController: UIViewController
  let centerViewController: UINavigationController
  
  var isOpening = false
  
  init(sideMenu: UIViewController, center: UINavigationController) {
    menuViewController = sideMenu
    centerViewController = center
    super.init(nibName: nil, bundle: nil)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    view.backgroundColor = .black
    setNeedsStatusBarAppearanceUpdate()
    
    addChildViewController(centerViewController)
    view.addSubview(centerViewController.view)
    centerViewController.didMove(toParentViewController: self)
    
    addChildViewController(menuViewController)
    view.addSubview(menuViewController.view)
    menuViewController.didMove(toParentViewController: self)

    menuViewController.view.layer.anchorPoint.x = 1.0
    menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.frame.height)
    (menuViewController as! SideMenuViewController).headerHeight = centerViewController.navigationBar.frame.size.height
    
    let panGesture = UIPanGestureRecognizer(target:self, action:#selector(ContainerViewController.handleGesture(_:)))
    view.addGestureRecognizer(panGesture)
    setMenu(toPercent: 0)
  }
  
  @objc func handleGesture(_ recognizer: UIPanGestureRecognizer) {
    
    let translation = recognizer.translation(in: recognizer.view!.superview!)
    
    var progress = translation.x / menuWidth * (isOpening ? 1.0 : -1.0)
    progress = min(max(progress, 0.0), 1.0)
    
    switch recognizer.state {
    case .began:
      let isOpen = floor(centerViewController.view.frame.origin.x/menuWidth)
      isOpening = isOpen == 1.0 ? false: true
      // Don't want zigzags as I rotate
      menuViewController.view.layer.shouldRasterize = true
      menuViewController.view.layer.rasterizationScale = UIScreen.main.scale
      
    case .changed:
      setMenu(toPercent: isOpening ? progress: (1.0 - progress))
      
    case .ended, .cancelled, .failed:
      
      var targetProgress: CGFloat
      if (isOpening) {
        targetProgress = progress < 0.5 ? 0.0 : 1.0
      } else {
        targetProgress = progress < 0.5 ? 1.0 : 0.0
      }
      
      UIView.animate(withDuration: animationTime,
        animations: {
          self.setMenu(toPercent: targetProgress)
        },
        completion: {_ in
          
        }
      )
      self.menuViewController.view.layer.shouldRasterize = false
    default: break
    }
  }
  
  func toggleSideMenu() {
    let isOpen = floor(centerViewController.view.frame.origin.x/menuWidth)
    let targetProgress: CGFloat = isOpen == 1.0 ? 0.0: 1.0
    
    UIView.animate(withDuration: animationTime,
      animations: {
        self.setMenu(toPercent: targetProgress)
      },
      completion: { _ in
        self.menuViewController.view.layer.shouldRasterize = false
      }
    )
  }
  
  func setMenu(toPercent percent: CGFloat) {
    centerViewController.view.frame.origin.x = menuWidth * CGFloat(percent)
    menuViewController.view.layer.transform = menuTransform(percent: percent)
    menuViewController.view.alpha = CGFloat(max(0.2, percent))
  }

  func menuTransform(percent: CGFloat) -> CATransform3D {
    var identity = CATransform3DIdentity
    // Why is this property called m34? view and layer transformations are expressed as two dimensional math matrices. In the case of a layer transform matrix, the element in the 3rd row at the 4th colomn sets your z axis perspective
    identity.m34 = -1/1000

    // at 0 percent, the angle is 90 degrees away (half pi). As percent increases we reduce angle back to 0
    let angle = (1 - percent) * -.pi / 2

    // Here you use rotationTransform to rotate the layer away from you around its y axis.
    let rotationTransform = CATransform3DRotate(identity, angle, 0, 1, 0)
    // The menu is moving in from the left, so you also create a translation transform to move it along the x axis, eventually to menu width at 100%.
    let translationTransform = CATransform3DMakeTranslation(menuWidth * percent, 0, 0)
    // Finally, you concatenate the two transforms and return the result.
    return CATransform3DConcat(rotationTransform, translationTransform)
  }
}
