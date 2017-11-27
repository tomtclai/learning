//
//  MenuHelper.swift
//  InteractiveSlideoutMenu
//
//  Created by Tom Lai on 26.11.17.
//  Copyright © 2017 Thorn Technologies, LLC. All rights reserved.
//

import Foundation
import UIKit

enum Direction {
    case up
    case down
    case left
    case right
}

struct MenuHelper {
    static let menuWidth: CGFloat = 0.8
    static let percentThreshold: CGFloat = 0.3
    static let snapshotNumber = 12345

    static func calculateProgress(translationInView: CGPoint, viewBounds: CGRect, direction: Direction) -> CGFloat {
        let pointOnAxis: CGFloat
        let axisLength: CGFloat
        switch direction {
        case .up, .down:
            pointOnAxis = translationInView.y
            axisLength = viewBounds.height
        case .left, .right:
            pointOnAxis = translationInView.x
            axisLength = viewBounds.width
        }

        let movementOnAxis = Float(pointOnAxis) / Float(axisLength)
        let positiveMovementOnAxis: Float
        switch direction {
        case .right, .down: // positive direction
            positiveMovementOnAxis = cap(movementOnAxis, min: 0, max: 1)
            return CGFloat(positiveMovementOnAxis)
        case .up, .left: // negative direction
            positiveMovementOnAxis = cap(movementOnAxis, min: -1, max: 0)
            return CGFloat(-positiveMovementOnAxis)
        }
    }
    static func cap(_ value: Float, min: Float, max: Float) -> Float {
        return fminf(fmaxf(value, min), max)
    }
    static func mapGestureStateToInteractor(gestureState: UIGestureRecognizerState, progress: CGFloat, interactor: Interactor?, triggerSegue: () -> Void) {
        guard let interactor = interactor else { return }
        switch gestureState {
        case .began:
            interactor.hasStarted = true
            print("began")
            triggerSegue()
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
            print("changed \(progress)")
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
            print("cancelled")
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ?
                interactor.finish() : interactor.cancel()
            if interactor.shouldFinish {
                print("ended: completed")
            } else {
                print("ended: cancelled")
            }
        default:
            break
        }
    }
}
