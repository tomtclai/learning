/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import QuartzCore

class ContainerViewController: UIViewController {
  enum SlideoutState {
    case bothCollapsed
    case leftPanelExpanded
    case rightPanelExpanded
  }

  var currentState: SlideoutState = .bothCollapsed {
    didSet {
      let shouldShowShadow = currentState != .bothCollapsed
      showShadowForCenterViewController(shouldShowShadow)
    }
  }
  var leftViewController: SidePanelViewController?
  var rightViewController: SidePanelViewController?
  var centerNavigationController: UINavigationController!
  var centerViewController: CenterViewController!
  private let centerPanelExpandedOffset: CGFloat = 60

  override func viewDidLoad() {
    super.viewDidLoad()

    centerViewController = UIStoryboard.centerViewController()
    centerViewController.delegate = self

    centerNavigationController = UINavigationController(rootViewController: centerViewController)

    view.addSubview(centerNavigationController.view)
    addChildViewController(centerNavigationController)

    centerNavigationController.didMove(toParentViewController: self)

    let panGestureReconizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    centerNavigationController.view.addGestureRecognizer(panGestureReconizer)
    panGestureReconizer.delegate = self
  }
}
extension ContainerViewController: UIGestureRecognizerDelegate {
  @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
    let containerView = view!
    let gestureIsFromLeftToRight = recognizer.velocity(in: view).x > 0

    switch recognizer.state {
    case .began:
      if currentState == .bothCollapsed {
        if gestureIsFromLeftToRight {
          addLeftPanelToSubview()
        } else {
          addRightPanelToSubview()
        }
        showShadowForCenterViewController(true)
      }
    case .changed:
      if let centerView = recognizer.view {
        centerView.center.x += recognizer.translation(in: view).x
        recognizer.setTranslation(.zero, in: view)
      }
    case .ended:
      guard let centerView = recognizer.view else {
        return
      }
      if let _ = leftViewController {
        let halfComplete = centerView.center.x > containerView.bounds.size.width
        animateLeftPanel(shouldExpand: halfComplete)
      } else if let _ = rightViewController {
        let halfComplete = centerView.center.x < 0
        animateRightPanel(shouldExpand: halfComplete)
      }
    default:
      break
    }
  }
}
extension ContainerViewController: CenterViewControllerDelegate {
  func toggleLeftPanel() {
    let leftPanelVisible = currentState == .leftPanelExpanded
    if !leftPanelVisible {
        addLeftPanelToSubview()
    }
    animateLeftPanel(shouldExpand: !leftPanelVisible)
  }
  func toggleRightPanel() {
    let rightPanelVisible = currentState == .rightPanelExpanded
    if !rightPanelVisible {
      addRightPanelToSubview()
    }
    animateRightPanel(shouldExpand: !rightPanelVisible)
  }
  func addLeftPanelToSubview() {
    guard leftViewController == nil,
      let vc = UIStoryboard.leftViewController() else {
      return
    }
    vc.animals = Animal.allCats()
    addSidePanelToSubview(vc)
    leftViewController = vc
  }
  func addRightPanelToSubview() {
    guard rightViewController == nil,
      let vc = UIStoryboard.rightViewController() else {
        return
    }
    vc.animals = Animal.allDogs()
    addSidePanelToSubview(vc)
    rightViewController = vc
  }
  func addSidePanelToSubview(_ sidePanelViewController: SidePanelViewController) {
    view.insertSubview(sidePanelViewController.view, at: 0)
    addChildViewController(sidePanelViewController)
    sidePanelViewController.didMove(toParentViewController: self)
  }
  func animateLeftPanel(shouldExpand: Bool) {
    guard shouldExpand else {
      collapseAllPanels()
      return
    }
    currentState = .leftPanelExpanded
    animateCenterPanelXPosition(targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)

  }
  func animateRightPanel(shouldExpand: Bool) {
    guard shouldExpand else {
      collapseAllPanels()
      return
    }
    currentState = .rightPanelExpanded
    animateCenterPanelXPosition(targetPosition: -centerNavigationController.view.frame.width + centerPanelExpandedOffset)
  }
  func collapseAllPanels() {
    animateCenterPanelXPosition(targetPosition: 0, completion: { [weak self] finished in
      self?.currentState = .bothCollapsed
      self?.leftViewController?.view.removeFromSuperview()
      self?.rightViewController?.view.removeFromSuperview()
      self?.leftViewController = nil
      self?.rightViewController = nil
    })
  }
  func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
      [weak self] in self?.centerNavigationController.view.frame.origin.x = targetPosition

      }, completion: completion)
  }
  func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
    if shouldShowShadow {
      centerNavigationController.view.layer.shadowOpacity = 0.8
    } else {
      centerNavigationController.view.layer.shadowOpacity = 0.0
    }
  }
}
private extension UIStoryboard {

  static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }

  static func leftViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewController(withIdentifier: "LeftViewController") as? SidePanelViewController
  }

  static func rightViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewController(withIdentifier: "RightViewController") as? SidePanelViewController
  }

  static func centerViewController() -> CenterViewController? {
    return mainStoryboard().instantiateViewController(withIdentifier: "CenterViewController") as? CenterViewController
  }
}
