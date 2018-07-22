/*
 * Copyright (c) 2016 Razeware LLC
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

private let RetinaToEyeScaleFactor: CGFloat = 0.5
private let FaceBoundsToEyeScaleFactor: CGFloat = 4.0

class PhotoDetailViewController: UIViewController {
  @IBOutlet weak var photoImageView: UIImageView!

  var image: UIImage!

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    assert(image != nil, "Image not set; required to use view controller")
    photoImageView.image = image

    // Resize if neccessary to ensure it's not pixelated
    if image.size.height <= photoImageView.bounds.size.height &&
      image.size.width <= photoImageView.bounds.size.width {
      photoImageView.contentMode = .center
    }

    DispatchQueue.global(qos: .userInitiated).async {
        let overlayImage = self.faceOverlayImageFromImage(self.image)
        DispatchQueue.main.async {
            self.fadeInNewImage(overlayImage)
        }
    }
  }

}

// MARK: - Private Methods

private extension PhotoDetailViewController {
  func faceOverlayImageFromImage(_ image: UIImage) -> UIImage {
    let detector = CIDetector(ofType: CIDetectorTypeFace,
                              context: nil,
                              options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])

    // Get features from the image
    let newImage = CIImage(cgImage: image.cgImage!)
    let features = detector?.features(in: newImage) as! [CIFaceFeature]!

    UIGraphicsBeginImageContext(image.size)
    let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)

    // Draws this in the upper left coordinate system
    image.draw(in: imageRect, blendMode: .normal, alpha: 1.0)

    let context = UIGraphicsGetCurrentContext()
    for faceFeature in features! {
      let faceRect = faceFeature.bounds
      context!.saveGState()

      // CI and CG work in different coordinate systems, we should translate to
      // the correct one so we don't get mixed up when calculating the face position.
      context!.translateBy(x: 0.0, y: imageRect.size.height)
      context!.scaleBy(x: 1.0, y: -1.0)

      if faceFeature.hasLeftEyePosition {
        let leftEyePosition = faceFeature.leftEyePosition
        let eyeWidth = faceRect.size.width / FaceBoundsToEyeScaleFactor
        let eyeHeight = faceRect.size.height / FaceBoundsToEyeScaleFactor
        let eyeRect = CGRect(x: leftEyePosition.x - eyeWidth / 2.0,
                             y: leftEyePosition.y - eyeHeight / 2.0,
                             width: eyeWidth,
                             height: eyeHeight)
        drawEyeBallForFrame(eyeRect)
      }

      if faceFeature.hasRightEyePosition {
        let leftEyePosition = faceFeature.rightEyePosition
        let eyeWidth = faceRect.size.width / FaceBoundsToEyeScaleFactor
        let eyeHeight = faceRect.size.height / FaceBoundsToEyeScaleFactor
        let eyeRect = CGRect(x: leftEyePosition.x - eyeWidth / 2.0,
                             y: leftEyePosition.y - eyeHeight / 2.0,
                             width: eyeWidth,
                             height: eyeHeight)
        drawEyeBallForFrame(eyeRect)
      }

      context!.restoreGState()
    }

    let overlayImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return overlayImage!
  }

  func faceRotationInRadians(leftEyePoint startPoint: CGPoint, rightEyePoint endPoint: CGPoint) -> CGFloat {
    let deltaX = endPoint.x - startPoint.x
    let deltaY = endPoint.y - startPoint.y
    let angleInRadians = CGFloat(atan2f(Float(deltaY), Float(deltaX)))

    return angleInRadians
  }

  func drawEyeBallForFrame(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    context?.addEllipse(in: rect)
    context?.setFillColor(UIColor.white.cgColor)
    context?.fillPath()

    let eyeSizeWidth = rect.size.width * RetinaToEyeScaleFactor
    let eyeSizeHeight = rect.size.height * RetinaToEyeScaleFactor

    var x = CGFloat(arc4random_uniform(UInt32(rect.size.width - eyeSizeWidth)))
    var y = CGFloat(arc4random_uniform(UInt32(rect.size.height - eyeSizeHeight)))
    x += rect.origin.x
    y += rect.origin.y

    let eyeSize = min(eyeSizeWidth, eyeSizeHeight)
    let eyeBallRect = CGRect(x: x, y: y, width: eyeSize, height: eyeSize)
    context?.addEllipse(in: eyeBallRect)
    context?.setFillColor(UIColor.black.cgColor)
    context?.fillPath()
  }

  func fadeInNewImage(_ newImage: UIImage) {
    let tmpImageView = UIImageView(image: newImage)
    tmpImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tmpImageView.contentMode = photoImageView.contentMode
    tmpImageView.frame = photoImageView.bounds
    tmpImageView.alpha = 0.0
    photoImageView.addSubview(tmpImageView)

    UIView.animate(withDuration: 0.75, animations: {
      tmpImageView.alpha = 1.0
    }, completion: {
      finished in
      self.photoImageView.image = newImage
      tmpImageView.removeFromSuperview()
    })
  }
}
