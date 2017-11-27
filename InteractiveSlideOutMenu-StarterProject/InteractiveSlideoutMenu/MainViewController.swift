//
//  MainViewController.swift
//  InteractiveSlideoutMenu
//
//  Created by Robert Chen on 2/7/16.
//  Copyright © 2016 Thorn Technologies, LLC. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let interactor = Interactor()
    @IBAction func openMenu(_ sender: AnyObject) {
        performSegue(withIdentifier: "openMenu", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MenuViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // return nil if you dont want it to be interaective.
        // I only want it to be interactive if user is panning
        return interactor.hasStarted ? interactor : nil
    }
}
