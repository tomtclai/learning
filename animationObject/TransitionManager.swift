//
//  TransitionManager.swift
//  animationObject
//
//  Created by Tom Lai on 10/20/15.
//  Copyright © 2015 Lai. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    var presenting = true
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        let container = transitionContext.containerView()
//        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
//        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
//        
//        
//        let offScreenRight = CGAffineTransformMakeTranslation(container!.frame.width, 0)
//        let offScreenLeft = CGAffineTransformMakeTranslation(-container!.frame.width, 0)
//        
//        // Start the toview to the right of the screen
//        toView.transform = self.presenting ? offScreenRight : offScreenLeft
//        
//        container?.addSubview(toView)
//        container?.addSubview(fromView)
//        
//        let duration = self.transitionDuration(transitionContext)
//        
//        
//        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(rawValue: 0), animations: {
//            
//            fromView.transform = self.presenting ? offScreenLeft : offScreenRight
//            
//            toView.transform = CGAffineTransformIdentity
//            
//            }, completion: { finished in
//                transitionContext.completeTransition(true)
//        })
//        
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!

        let offScreenRotateIn = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        let offScreenRotateOut = CGAffineTransformMakeRotation(-CGFloat(M_PI_2))

        toView.transform = self.presenting ? offScreenRotateIn : offScreenRotateOut

        container?.addSubview(toView)
        container?.addSubview(fromView)

        let duration = self.transitionDuration(transitionContext)

        toView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        fromView.layer.anchorPoint = CGPoint(x: 0, y: 0)

        toView.layer.position = CGPoint(x: 0, y: 0)
        fromView.layer.position = CGPoint(x: 0, y: 0)

        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            fromView.transform = self.presenting ? offScreenRotateIn : offScreenRotateOut
            toView .transform = CGAffineTransformIdentity
            }, completion: {finished in
        transitionContext.completeTransition(true)
        })
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
