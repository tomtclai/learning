//
//  PopAnimator.swift
//  BeginnerCook
//
//  Created by Tom Lai on 1/4/18.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
enum TransitionDirection {
  case presenting
  case dismissing
}
class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

  let duration = 1.0
  var direction = TransitionDirection.presenting
  var scrollViewCellFrame = CGRect.zero

  var dismissCompletion: (() -> Void)?

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let toView = transitionContext.view(forKey: .to)!

    var herbDetailsViewController: HerbDetailsViewController?
    var herbDetailView: UIView!
    var toFrame: CGRect!
    var fromFrame: CGRect!
    var xScaleFactor: CGFloat!
    var yScaleFactor: CGFloat!

    switch direction {
    case .presenting:
      herbDetailView = toView
      herbDetailsViewController = transitionContext.viewController(forKey: .to) as? HerbDetailsViewController
      toFrame = scrollViewCellFrame
      fromFrame = herbDetailView.frame
      xScaleFactor = toFrame.width / fromFrame.width
      yScaleFactor = toFrame.height / fromFrame.height
    case .dismissing:
      herbDetailView = transitionContext.view(forKey: .from)!
      herbDetailsViewController = transitionContext.viewController(forKey: .from) as? HerbDetailsViewController
      toFrame = herbDetailView.frame
      fromFrame = scrollViewCellFrame
      xScaleFactor = fromFrame.width / toFrame.width
      yScaleFactor = fromFrame.height / toFrame.height
    }

    let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

    if direction == .presenting {
      herbDetailView.transform = scaleTransform
      herbDetailView.center = CGPoint(x: toFrame.midX, y: toFrame.midY)
      herbDetailView.clipsToBounds = true
      herbDetailsViewController?.containerView.alpha = 0
    }

    containerView.addSubview(toView)
    containerView.bringSubview(toFront: herbDetailView)

    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, animations: {
      herbDetailView.center = CGPoint(x: fromFrame.midX, y: fromFrame.midY)
      switch self.direction {
      case .presenting:
        herbDetailView.transform = .identity
        // corner radius is one of the few special layer properties UIKit can animate
//        herbDetailView.layer.cornerRadius = 0
        herbDetailsViewController?.containerView.alpha = 1
      case .dismissing:
        herbDetailView.transform = scaleTransform
//        herbDetailView.layer.cornerRadius = 20
        herbDetailsViewController?.containerView.alpha = 0
      }

    }, completion: { _ in
      if self.direction == .dismissing {
        self.dismissCompletion?()
      }
      transitionContext.completeTransition(true)
    })

    let cornerAnimation = CABasicAnimation(keyPath: "cornerRadius")
    cornerAnimation.duration = duration / 2
    switch direction {
    case .presenting:
      cornerAnimation.fromValue = 20 / xScaleFactor
      cornerAnimation.toValue = 0
    case .dismissing:
      cornerAnimation.fromValue = 0
      cornerAnimation.toValue = 20 / xScaleFactor
    }
    herbDetailView.layer.add(cornerAnimation, forKey: nil)
  }

}
