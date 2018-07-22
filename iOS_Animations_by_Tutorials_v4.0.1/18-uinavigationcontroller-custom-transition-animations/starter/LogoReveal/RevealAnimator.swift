//
//  RevealAnimator.swift
//  LogoReveal
//
//  Created by Tom Lai on 1/6/18.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import UIKit

class RevealAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
  private var pausedTime: CFTimeInterval = 0
  let animationDuration = 2.0
  var operation: UINavigationControllerOperation = .push
  weak var storedContext: UIViewControllerContextTransitioning?
  var interactive = false

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if interactive {
      let transitionLayer = transitionContext.containerView.layer
      pausedTime = transitionLayer.convertTime(CACurrentMediaTime(), to: nil)
      transitionLayer.speed = 0
      transitionLayer.timeOffset = pausedTime
    }
    storedContext =  transitionContext
    switch operation {
    case .push:
      let fromVC = transitionContext.viewController(forKey: .from) as! MasterViewController
      let toVC = transitionContext.viewController(forKey: .to) as! DetailViewController

      transitionContext.containerView.addSubview(toVC.view)
      toVC.view.frame = transitionContext.finalFrame(for: toVC)

      let fade = CABasicAnimation(keyPath: "opacity")
      fade.fromValue = 0
      fade.toValue = 1
      fade.duration = animationDuration
      toVC.view.layer.add(fade, forKey: nil)

      let zoomIn = CABasicAnimation(keyPath: "transform")
      zoomIn.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
      zoomIn.toValue = NSValue(
        caTransform3D: CATransform3DConcat(
          CATransform3DMakeTranslation(0, -10, 0),
          CATransform3DMakeScale(150, 150, 1)
      ))
      zoomIn.duration = animationDuration
      zoomIn.delegate = self
      zoomIn.fillMode = kCAFillModeForwards
      zoomIn.isRemovedOnCompletion = false
      zoomIn.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

      let maskLayer: CAShapeLayer = RWLogoLayer.logoLayer()
      maskLayer.position = fromVC.logo.position
      toVC.view.layer.mask = maskLayer
      maskLayer.add(zoomIn, forKey: nil)
      fromVC.logo.add(zoomIn, forKey: nil)
    case .pop:
      let fromView = transitionContext.view(forKey: .from)! // detail
      let toView = transitionContext.view(forKey: .to)! // master
      transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
      // you can technically use UIView API for this
      let zoomOut = CABasicAnimation(keyPath: "transform")
      zoomOut.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
      zoomOut.toValue = NSValue(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 1))
      zoomOut.duration = animationDuration
      zoomOut.fillMode = kCAFillModeForwards
      zoomOut.isRemovedOnCompletion = false
      zoomOut.delegate = self

      fromView.layer.add(zoomOut, forKey: nil)

      return
    default:
      return
    }
  }

  override func update(_ percentComplete: CGFloat) {
    super.update(percentComplete)
    let animationProgressInSeconds = TimeInterval(animationDuration) * TimeInterval(percentComplete)
    storedContext?.containerView.layer.timeOffset = pausedTime + animationProgressInSeconds
  }
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if let context = storedContext {
      context.completeTransition(!context.transitionWasCancelled)
      //reset logo
      let fromVC = context.viewController(forKey: .from) as? MasterViewController
      fromVC?.logo.removeAllAnimations()

      let toVC = context.viewController(forKey: .to) as? DetailViewController
      toVC?.view.layer.mask = nil
    }
    storedContext = nil
  }

  func handlePan(_ recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: recognizer.view!.superview!)
    var progress = pythagoreanDistance(translation) / 200
    progress = min(max(progress, 0.01), 0.99)
    switch recognizer.state {
    case .changed:
      update(progress)
    case .cancelled, .ended:
      if progress < 0.5 {
        cancel()
      } else {
        finish()
      }
      interactive = false
    default:
      break
    }
  }

  override func cancel() {
    restart(forFinishing: false)
    super.cancel()
  }
  override func finish() {
    restart(forFinishing: true)
    super.finish()
  }
  private func restart(forFinishing: Bool) {
    if let transitionLayer = storedContext?.containerView.layer {
      transitionLayer.beginTime = CACurrentMediaTime()
      transitionLayer.speed = forFinishing ? 1 : -1
    }
  }
  func pythagoreanDistance(_ translation: CGPoint) -> CGFloat {
    return CGFloat(sqrt(
        (translation.x * translation.x) +
        (translation.y * translation.y)
    ))
  }
}
