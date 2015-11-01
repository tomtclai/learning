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
//    private var statusBarBackground: UIView!
    private var interactive = false
    private var menuWidth : CGFloat!
    var presenting = true
    
    var sourceViewController: UIViewController! {
        didSet {
            menuWidth = UIScreen.mainScreen().bounds.size.width * 0.8
            self.enterPanGesture = UIScreenEdgePanGestureRecognizer()
            self.enterPanGesture.addTarget(self, action: "handleOnstagePan:")
            self.enterPanGesture.edges = UIRectEdge.Left
            self.sourceViewController.view.addGestureRecognizer(self.enterPanGesture)
            self.sourceViewController.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissMenu:"))
            
        }
    }
    
    
    var menuViewController: MenuViewController! {
        didSet {
            menuViewController.view.frame.size = CGSizeMake(menuWidth, menuViewController.view.frame.size.height)
            self.exitPanGesture = UIPanGestureRecognizer()
            self.exitPanGesture.addTarget(self, action: "handleExitPan:")
            UIApplication.sharedApplication().windows.first?.addGestureRecognizer(exitPanGesture)
            
        }
    }
    

    
    
    func handleOnstagePan(pan: UIPanGestureRecognizer) {
        presenting = true
        
        let translation = pan.translationInView(pan.view!) // pan.view is sourceView
        
        let d = translation.x / menuWidth
        switch (pan.state) {
        case .Began:
            self.interactive = true
            self.sourceViewController.performSegueWithIdentifier("presentMenu", sender: self)
        case .Changed:
            self.updateInteractiveTransition(d)
        default:
            self.interactive = true
            if (d > 0.1) {
                self.finishInteractiveTransition()
            } else {
                self.cancelInteractiveTransition()

            }
            self.interactive = false
        }
    }
    
    func dismissMenu(tap: UITapGestureRecognizer) {
        presenting = false
        if menuViewController != nil {
            self.menuViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func handleExitPan(pan: UIPanGestureRecognizer) {
        let translation = pan.translationInView(pan.view!)
        presenting = false

            let percentComplete =  -translation.x / menuWidth
            switch (pan.state) {
            case .Began:
                if (translation.x < 0) { // right to left
                    self.interactive = true
                    self.menuViewController.performSegueWithIdentifier("unwindToMainView", sender: self)
                }
            case .Changed:
                self.updateInteractiveTransition(percentComplete)
            default:
                self.interactive = false
                if percentComplete > 0.1 {
                    self.finishInteractiveTransition()
                } else {
                    self.cancelInteractiveTransition()
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
//        container!.addSubview(self.statusBarBackground)
        
        let duration = self.transitionDuration(transitionContext)
        

        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: UIViewAnimationOptions(rawValue: 0), animations: {
            
            menuView.alpha = self.presenting ? 1 : 0
            
            if self.presenting { // fade in
//                menuView.alpha = 1
                
                self.onStageMenuController(self.menuViewController)
            } else { // fade out
//                menuView.alpha = 0
                self.offStageMenuController(self.menuViewController)
            }
            
            }, completion: { finished in
                
                if (transitionContext.transitionWasCancelled()) {
                    transitionContext.completeTransition(false)
                    // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                    UIApplication.sharedApplication().keyWindow!.addSubview(screens.from.view)
//                    UIApplication.sharedApplication().keyWindow!.addSubview(self.statusBarBackground)
                    
                } else {
                    transitionContext.completeTransition(true)
                    // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                    UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
//                    UIApplication.sharedApplication().keyWindow!.addSubview(self.statusBarBackground)
                }
                
                
            }
        )
    }
    
    
    func offStage(amount: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(amount, 0)
    }
    
    func offStageMenuController(menuViewController : MenuViewController) {
//        menuViewController.view.alpha = 0
        
        let offset : CGFloat = -CGRectGetWidth(sourceViewController.view.frame)
//
        menuViewController.view.transform = self.offStage(offset)
    }
    
    func onStageMenuController(menuViewController : MenuViewController) {

        menuViewController.view.transform = CGAffineTransformIdentity


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
