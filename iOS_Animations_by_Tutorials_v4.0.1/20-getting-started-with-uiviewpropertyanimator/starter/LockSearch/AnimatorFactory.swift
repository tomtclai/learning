//
//  AnimatorFactory.swift
//  Widgets
//
//  Created by Tom Lai on 1/7/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

import UIKit

// In your own projects you might want to prefer using an enum or struct fo this
class AnimatorFactory {
  static func scaleUp(view: UIView) -> UIViewPropertyAnimator {
    let scale = UIViewPropertyAnimator(duration: 0.33, curve: .easeIn)
    scale.addAnimations {
      view.alpha = 1.0
    }
    scale.addAnimations({
      view.transform = CGAffineTransform.identity
    }, delayFactor: 0.33)
    scale.addCompletion { _ in
      print("ready")
    }
    return scale
  }

  @discardableResult
  static func jiggle(view: UIView) -> UIViewPropertyAnimator {
    return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.33, delay: 0, animations: {
      UIView.animateKeyframes(withDuration: 1, delay: 0, animations: {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
          view.transform = CGAffineTransform(rotationAngle: -.pi/8)
        })
        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
          view.transform = CGAffineTransform(rotationAngle: .pi/8)
        })
        UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
          view.transform = CGAffineTransform.identity
        })
      }, completion: { _ in
        // in case animation was interrupted
        view.transform = .identity
      })
    }, completion: { _ in

    })
  }

  @discardableResult
  static func fadeIn(view: UIView, visible: Bool) -> UIViewPropertyAnimator {
    return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
      view.alpha = visible ? 1 : 0
    }, completion: nil)
  }

  @discardableResult
  static func animateConstraint(view: UIView, constraint: NSLayoutConstraint, by delta: CGFloat) -> UIViewPropertyAnimator {
    let springTimingParameters = UISpringTimingParameters(dampingRatio: 0.55)
    let animator = UIViewPropertyAnimator(duration: 1, timingParameters: springTimingParameters)
    animator.addAnimations {
      constraint.constant += delta
      view.layoutIfNeeded()
    }
    return animator
  }
}
