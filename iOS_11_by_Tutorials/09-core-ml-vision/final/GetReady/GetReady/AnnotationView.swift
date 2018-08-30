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
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import UIKit

let hat = #imageLiteral(resourceName: "Park Hat")
let glasses = #imageLiteral(resourceName: "Sunglasses")

class AnnotationLayer: UIView {
  var drawDebug = false

  var faces: [FaceDimensions] = [] {
    didSet {
      setNeedsDisplay()
    }
  }

  var classification: SceneType = .other {
    didSet {
      setNeedsDisplay()
    }
  }

  var annotationColor: UIColor = .green

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    drawFaceAnnotations()
    drawEyeAnnotations()
    drawMedianAnnotation()
  }

  private func drawFaceAnnotations() {
    for face in faces.reversed() {
      guard let faceRect = face.faceRect else { continue }
      if drawDebug {
        outlineFace(faceRect: faceRect)
      }

      drawHat(faceRect: faceRect, median: face.median)
    }
  }

  private func drawHat(faceRect: CGRect, median: [CGPoint]?) {
    guard classification == .forest else { return }

    let hatSize = hat.size
    let headSize = faceRect.size
    let hatWidthForHead = (3.0 / 2.0) * headSize.width
    let hatRatio = hatWidthForHead / hatSize.width

    let scaleTransform = CGAffineTransform(scaleX: hatRatio,
                                           y: hatRatio)
    let adjustedHatSize = hatSize.applying(scaleTransform)

    let hatRect = CGRect(x: faceRect.midX -
      (adjustedHatSize.width / 2.0),
                         y: faceRect.minY - adjustedHatSize.height,
                         width: adjustedHatSize.width,
                         height: adjustedHatSize.height)

    drawAngled(to: median, in: hatRect, image: hat)
  }

  private func outlineFace(faceRect: CGRect) {
    let path = UIBezierPath(rect: faceRect)
    annotationColor.setStroke()
    path.stroke()
  }

  private func drawEyeAnnotations() {
    for face in faces {
      if drawDebug {
        if let left = face.leftEye {
          outlineFeature(points: left)
        }
        if let right = face.rightEye {
          outlineFeature(points: right)
        }
      }

      if let left = face.leftEye, let right = face.rightEye {
        drawGlasses(left: left, right: right, median: face.median)
      }
    }
  }

  private func drawGlasses(left: [CGPoint], right: [CGPoint],
                           median: [CGPoint]? ) {

    guard classification == .beach else { return }

    let total = left + right
    let minX = total.reduce(CGFloat.infinity) { min($0, $1.x) }
    let minY = total.reduce(CGFloat.infinity) { min($0, $1.y) }
    let maxX = total.reduce(0) { max($0, $1.x) }
    let maxY = total.reduce(0) { max($0, $1.y) }

    let width = max(maxX - minX, 16.0)
    let x = (maxX - minX) / 2.0 + minX - width / 2.0

    let height = max(maxY - minY, 8.0)
    let y = (maxY - minY) / 2.0 + minY - height / 2.0

    let eyesRect = CGRect(x: x, y: y,
                          width: width, height: height)

    drawAngled(to: median, in: eyesRect, image: glasses)
  }

  private func drawMedianAnnotation() {
    for face in faces {
      if drawDebug, let median = face.median {
        outlineFeature(points: median)
      }
    }
  }

  private func outlineFeature(points: [CGPoint], fill: Bool = false) {
    annotationColor.setStroke()
    annotationColor.setFill()
    let path = UIBezierPath()
    path.move(to: points.first!)
    for point in points {
      path.addLine(to: point)
    }
    if fill {
      path.close()
      path.fill()
    }
    path.stroke()
  }

  private func drawAngled(to median: [CGPoint]?,
                                  in accessoryRect: CGRect,
                                  image: UIImage) {
    if let median = median, median.count >= 2 {

      let top = median.first!
      let bottom = median.last!
      let estimatedSlope = (top.y - bottom.y)
        / (top.x - bottom.x )
      let degrees = atan2(1, estimatedSlope)
        + (estimatedSlope < 0 ? CGFloat.pi : 0)

      let context = UIGraphicsGetCurrentContext()
      context?.saveGState()

      context?.translateBy(x: accessoryRect.midX,
                           y: accessoryRect.midY)
      let angle: CGFloat = -degrees
      context?.rotate(by: angle)

      context?.translateBy(x: -accessoryRect.width / 2
        - (accessoryRect.midX - top.x),
                           y: -accessoryRect.height / 2)
      let drawRect = CGRect(origin: .zero,
                            size: accessoryRect.size)
      image.draw(in: drawRect)

      context?.restoreGState()
    } else {
      image.draw(in: accessoryRect)
    }
  }
}
