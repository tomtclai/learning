/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class MapViewController: UIViewController {
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var legendContainer: UIView!
	@IBOutlet weak var desiredXConstraint: NSLayoutConstraint!
  @IBOutlet weak var desiredYConstraint: NSLayoutConstraint!
  @IBOutlet weak var marker: UIView!
  @IBOutlet weak var markerImageView: UIImageView!
	private let scrollIndicatorMargin: CGFloat = 8
	private let legendCornerRadius: CGFloat = 8

  override func viewDidLoad() {
    super.viewDidLoad()

		setupLegend()
    marker.layoutIfNeeded()
    decideArrowOrX()
  }

	private func setupLegend() {
		legendContainer.layer.cornerRadius = legendCornerRadius
		legendContainer.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: scrollIndicatorMargin).isActive = true
		legendContainer.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -scrollIndicatorMargin).isActive = true
		legendContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: legendContainer.frame.height).isActive = true
		additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: legendContainer.frame.height + scrollIndicatorMargin, right: scrollIndicatorMargin)
		scrollView.contentInsetAdjustmentBehavior = .never
	}

  func decideArrowOrX() {
    let currentPoint = marker.frame.origin
    let desiredPoint = CGPoint(x: desiredXConstraint.constant, y: desiredYConstraint.constant)
    if currentPoint == desiredPoint {
      markerImageView.image = UIImage(named: "x")
      markerImageView.transform = CGAffineTransform.identity
    } else {
      markerImageView.image = UIImage(named: "arrow")
      let angle = angleBetween(currentPoint, desiredPoint)
      markerImageView.transform = CGAffineTransform(rotationAngle: angle)
    }
  }

  func angleBetween(_ firstPoint: CGPoint, _ secondPoint: CGPoint) -> CGFloat {
    let deltaX = secondPoint.x - firstPoint.x
    let deltaY = secondPoint.y - firstPoint.y
    return atan2(deltaY, deltaX)
  }
}

extension MapViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    decideArrowOrX()
  }
}
