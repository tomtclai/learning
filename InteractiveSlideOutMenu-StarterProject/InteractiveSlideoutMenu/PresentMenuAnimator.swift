//
//  PresentMenuAnimator.swift
//  InteractiveSlideoutMenu
//
//  Created by Tom Lai on 26.11.17.
//  Copyright © 2017 Thorn Technologies, LLC. All rights reserved.
//

import Foundation
import UIKit
class PresentMenuAnimator: NSObject {}

extension PresentMenuAnimator: UIViewControllerAnimatedTransitioning {
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
        containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)

        guard let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false) else { return }
        snapshot.tag = MenuHelper.snapshotNumber
        snapshot.isUserInteractionEnabled = false
        snapshot.layer.shadowOpacity = 0.7
        containerView.insertSubview(snapshot, aboveSubview: toVC.view)
        fromVC.view.isHidden = true

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapshot.center.x += UIScreen.main.bounds.width * MenuHelper.menuWidth
        }) { _ in
            fromVC.view.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
}
