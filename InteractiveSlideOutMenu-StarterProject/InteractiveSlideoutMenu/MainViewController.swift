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
        openMenu()
    }
    private func openMenu() {
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
    @IBAction func handleGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .right)
        MenuHelper.mapGestureStateToInteractor(gestureState: sender.state, progress: progress, interactor: interactor) {
            openMenu()

        }
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    // implement this for DIMISSAL to be interactive
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    // implement this for PRESENTATION to be interactive
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
