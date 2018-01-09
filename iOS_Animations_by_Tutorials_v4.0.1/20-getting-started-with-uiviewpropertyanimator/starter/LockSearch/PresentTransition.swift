//
//  PresentTransition.swift
//  Widgets
//
//  Created by Tom Lai on 1/9/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

import UIKit
typealias EmptyCallback = (()-> Void)?
class PresentTransition: NSObject, UIViewControllerAnimatedTransitioning {

  var auxAnimations: EmptyCallback = nil
  var auxAnimationsCancel: EmptyCallback = nil

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.75
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    transitionAnimator(using: transitionContext).startAnimation()
  }

  func transitionAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    let duration = transitionDuration(using: transitionContext)
    let container = transitionContext.containerView
    let to = transitionContext.view(forKey: .to)!

    container.addSubview(to)


    // scale up, move down
    to.transform = CGAffineTransform(scaleX: 1.33, y: 1.33)
      .concatenating(CGAffineTransform(translationX: 0, y: 200))

    // transparent
    to.alpha = 0


    let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
    animator.addAnimations({
      to.transform = CGAffineTransform(translationX: 0, y: 100)
    }, delayFactor: 0.15)

    animator.addAnimations({
      to.alpha = 1
    }, delayFactor: 0.5)

    if let auxAnimations = auxAnimations {
      animator.addAnimations(auxAnimations)
    }

    animator.addCompletion{_ in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    return animator
  }
}
