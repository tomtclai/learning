/*
 * Copyright (c) 2016-present Razeware LLC
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

class WidgetCell: UITableViewCell {

  private var showsMore = false
  @IBOutlet weak var widgetHeight: NSLayoutConstraint!

  weak var tableView: UITableView?
  var toggleHeightAnimator: UIViewPropertyAnimator?

  @IBOutlet weak var widgetView: WidgetView!

  var owner: WidgetsOwnerProtocol? {
    didSet {
      if let owner = owner {
        widgetView.owner = owner
      }
    }
  }

  @IBAction func toggleShowMore(_ sender: UIButton) {

    self.showsMore = !self.showsMore
//
//    self.widgetHeight.constant = self.showsMore ? 230 : 130
//    self.tableView?.reloadData()
//
//    widgetView.expanded = showsMore
//    widgetView.reload()
    let animations = {
      self.widgetHeight.constant = self.showsMore ? 230 : 130
      if let tableView = self.tableView {
        // a little trick, first you change the constraints. then you call begin updates and end updates so UIKit will ask all cells about their height and layout as needed
          tableView.beginUpdates()
          tableView.endUpdates()
          tableView.layoutIfNeeded()
      }
    }

    let textTransition = {
      UIView.transition(with: sender, duration: 0.25, options: .transitionFlipFromTop, animations: {
        sender.setTitle(self.showsMore ? "Show Less" : "Show More", for: .normal)
      }, completion: nil)
    }

    let spring = UISpringTimingParameters(mass: 30, stiffness: 1000, damping: 300, initialVelocity: CGVector(dx: 5, dy: 0))
    let shouldAddAnimation = toggleHeightAnimator != nil && toggleHeightAnimator!.isRunning
    if shouldAddAnimation {
      toggleHeightAnimator!.pauseAnimation()
    } else {
      toggleHeightAnimator = UIViewPropertyAnimator(duration: 0, timingParameters: spring)
    }
    toggleHeightAnimator?.addAnimations(animations)
    toggleHeightAnimator?.addAnimations(textTransition, delayFactor: 0.5)

    if shouldAddAnimation {
      toggleHeightAnimator?.continueAnimation(withTimingParameters: spring, durationFactor: 1)

    } else {
      toggleHeightAnimator?.startAnimation()
    }
    widgetView.expanded = showsMore
    widgetView.reload()

  }
}
