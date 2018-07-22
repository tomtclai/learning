//
//  DismissMenuAnimator.swift
//  InteractiveSlideoutMenu
//
//  Created by Tom Lai on 26.11.17.
//  Copyright © 2017 Thorn Technologies, LLC. All rights reserved.
//

import Foundation
import UIKit
class DismissMenuAnimator: NSObject {}

extension DismissMenuAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }

        let containerView = transitionContext.containerView
        let snapshot = containerView.viewWithTag(MenuHelper.snapshotNumber)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapshot?.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)

        }) { _ in
            let transitionWasCompleted = !transitionContext.transitionWasCancelled
            if transitionWasCompleted {
                containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
                snapshot?.removeFromSuperview()
            }
            transitionContext.completeTransition(transitionWasCompleted)
        }
    }
}
