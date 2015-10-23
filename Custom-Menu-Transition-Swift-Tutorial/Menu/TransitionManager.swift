//
//  TransitionManager.swift
//  Menu
//
//  Created by Tom Lai on 10/20/15.
//  Copyright © 2015 Mat. All rights reserved.
//

import UIKit

class TransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private var enterPanGesture: UIScreenEdgePanGestureRecognizer!
    private var exitPanGesture: UIPanGestureRecognizer!
    private var statusBarBackground: UIView!
    private var interactive = false
    
    var presenting = true
    
    var sourceViewController: UIViewController! {
        didSet {
            self.enterPanGesture = UIScreenEdgePanGestureRecognizer()
            self.enterPanGesture.addTarget(self, action: "handleOnstagePan:")
            self.enterPanGesture.edges = UIRectEdge.Left
            self.sourceViewController.view.addGestureRecognizer(self.enterPanGesture)
            
            self.statusBarBackground = UIView()
            self.statusBarBackground.frame = CGRect(x: 0, y: 0, width: self.sourceViewController.view.frame.width, height: 20)
            self.statusBarBackground.backgroundColor = self.sourceViewController.view.backgroundColor
            
            UIApplication.sharedApplication().keyWindow?.addSubview(self.statusBarBackground)

            
        }
    }
    
    var menuViewController: MenuViewController! {
        didSet {
            self.exitPanGesture = UIPanGestureRecognizer()
            self.exitPanGesture.addTarget(self, action: "handleExitPan:")
            self.menuViewController.view.addGestureRecognizer(exitPanGesture)
        }
    }
    

    
    
    func handleOnstagePan(pan: UIPanGestureRecognizer) {
        presenting = true
        let translation = pan.translationInView(pan.view!) // pan.view is sourceView
        
        let d = translation.x / CGRectGetWidth(pan.view!.bounds) * 0.5
        
        switch (pan.state) {
        case .Began:
            self.interactive = true
            self.sourceViewController.performSegueWithIdentifier("presentMenu", sender: self)
        case .Changed:
            self.updateInteractiveTransition(d)
        default:
            self.interactive = false
            if (d > 0.2) {
                self.finishInteractiveTransition()
            } else {
                self.cancelInteractiveTransition()
                
            }
        }
    }
    
    func handleExitPan(pan: UIPanGestureRecognizer) {
        let velocity = pan.velocityInView(pan.view!)
        presenting = false
        if (velocity.x < 0) { // right to left
            let percentComplete =  abs(pan.translationInView(pan.view).x) / CGRectGetWidth(pan.view!.bounds) * 0.5
            switch (pan.state) {
            case .Began:
                self.interactive = true
                self.menuViewController.performSegueWithIdentifier("unwindToMainView", sender: self)
            case .Changed:
                self.updateInteractiveTransition(percentComplete)
            default:
                self.interactive = false
                if percentComplete > 0.2 {
                    self.finishInteractiveTransition()
                } else {
                    self.cancelInteractiveTransition()
                }
            }
        }
    }
    //MARK: UIViewCOntrollerAnimatedTransitioning
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        
        let screens: (from:UIViewController, to:UIViewController) =
        (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!,
            transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        // assign references to our menu view controller and the 'bottom' view controller from the tuple
        // remember that our menuViewController will alternate between the from and to view controller depending if we're presenting or dismissing
        var bottomViewController: UIViewController!
        
        if presenting { // from main to menu
            menuViewController = screens.to as! MenuViewController
            bottomViewController = screens.from 
        } else { // from menu to main
            menuViewController = screens.from as! MenuViewController
            bottomViewController = screens.to
        }
        
        let menuView = menuViewController.view
        let bottomView = bottomViewController.view
        
        if presenting {
            menuView.alpha = 0
            self.offStageMenuController(menuViewController)
        }
        container!.addSubview(bottomView)
        container!.addSubview(menuView)
        container!.addSubview(self.statusBarBackground)
        
        let duration = self.transitionDuration(transitionContext)
        
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(rawValue: 0), animations: {
            
            menuView.alpha = self.presenting ? 1 : 0
            
            if self.presenting { // fade in
                menuView.alpha = 1
                
                self.onStageMenuController(self.menuViewController)
            } else { // fade out
                menuView.alpha = 0
                self.offStageMenuController(self.menuViewController)
            }
            
            }, completion: { finished in
                
                if (transitionContext.transitionWasCancelled()) {
                    transitionContext.completeTransition(false)
                    // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                    UIApplication.sharedApplication().keyWindow!.addSubview(screens.from.view)
                    UIApplication.sharedApplication().keyWindow!.addSubview(self.statusBarBackground)
                } else {
                    transitionContext.completeTransition(true)
                    // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                    UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
                    UIApplication.sharedApplication().keyWindow!.addSubview(self.statusBarBackground)
                }
                
                
            }
        )
    }
    
    
    func offStage(amount: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(amount, 0)
    }
    
    func offStageMenuController(menuViewController : MenuViewController) {
        menuViewController.view.alpha = 0
        
        let topRowOffset  :CGFloat = 50
        let middleRowOffset :CGFloat = 150
        let bottomRowOffset  :CGFloat = 300
        

        
        menuViewController.textPostIcon.transform = self.offStage(-topRowOffset)
        menuViewController.textPostLabel.transform = self.offStage(-topRowOffset)
        
        menuViewController.quotePostIcon.transform = self.offStage(-middleRowOffset)
        menuViewController.quotePostLabel.transform = self.offStage(-middleRowOffset)
        
        menuViewController.chatPostIcon.transform = self.offStage(-bottomRowOffset)
        menuViewController.chatPostLabel.transform = self.offStage(-bottomRowOffset)
        
        menuViewController.photoPostIcon.transform = self.offStage(topRowOffset)
        menuViewController.photoPostLabel.transform = self.offStage(topRowOffset)
        
        menuViewController.linkPostIcon.transform = self.offStage(middleRowOffset)
        menuViewController.linkPostLabel.transform = self.offStage(middleRowOffset)
        
        menuViewController.audioPostIcon.transform = self.offStage(bottomRowOffset)
        menuViewController.audioPostLabel.transform = self.offStage(bottomRowOffset)

    }
    
    func onStageMenuController(menuViewController : MenuViewController) {
        menuViewController.textPostIcon.transform = CGAffineTransformIdentity
        menuViewController.textPostLabel.transform = CGAffineTransformIdentity
        menuViewController.quotePostIcon.transform = CGAffineTransformIdentity
        menuViewController.quotePostLabel.transform = CGAffineTransformIdentity
        menuViewController.chatPostIcon.transform = CGAffineTransformIdentity
        menuViewController.chatPostLabel.transform = CGAffineTransformIdentity
        
        menuViewController.photoPostIcon.transform = CGAffineTransformIdentity
        menuViewController.photoPostLabel.transform = CGAffineTransformIdentity
        menuViewController.linkPostIcon.transform = CGAffineTransformIdentity
        menuViewController.linkPostLabel.transform = CGAffineTransformIdentity
        menuViewController.audioPostIcon.transform = CGAffineTransformIdentity
        menuViewController.audioPostLabel.transform = CGAffineTransformIdentity
    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    
    // UIviewControllerTranstionDelegate
    // return the animataor when presenting a viewcontroller
    // rememeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presenting = false
        return self
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self : nil
    }
}
