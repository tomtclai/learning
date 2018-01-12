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
  @IBOutlet weak var desiredXConstraint: NSLayoutConstraint!
  @IBOutlet weak var desiredYConstraint: NSLayoutConstraint!
  @IBOutlet weak var marker: UIView!
  @IBOutlet weak var markerImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    marker.layoutIfNeeded()
    decideArrowOrX()
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
