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

import UIKit
import Vision
import ImageIO

class ImageViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var annotationView: AnnotationLayer!

  var image: UIImage! {
    didSet {
      imageView?.image = image
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never

    imageView.image = image
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    guard let cgImage = image.cgImage else {
      print("can't create CIImage from UIImage")
      return
    }

    let orientation = CGImagePropertyOrientation(
      image.imageOrientation)

    let faceRequest = VNDetectFaceLandmarksRequest(
      completionHandler: handleFaces)

    let handler = VNImageRequestHandler(cgImage: cgImage,
                                        orientation: orientation)

    var requests: [VNRequest] = [faceRequest]
    let leNetPlaces = GoogLeNetPlaces()
    if let model = try? VNCoreMLModel(for: leNetPlaces.model) {
       let mlRequest = VNCoreMLRequest(model: model,
                                       completionHandler: handleClassification)
      requests.append(mlRequest)
    }

    DispatchQueue.global(qos: .userInteractive).async {
      do {
        try handler.perform(requests)
      } catch {
        print("Error handling vision request \(error)")
      }
    }
  }

  func handleFaces(request: VNRequest, error: Error?) {
    guard let observations = request.results
      as? [VNFaceObservation] else {
        print("unexpected result type from face request")
        return
    }

    DispatchQueue.main.async {
      self.handleFaces(observations: observations)
    }
  }

  func handleFaces(observations: [VNFaceObservation]) {
    var faces: [FaceDimensions] = []

    // 1
    let viewSize = imageView.bounds.size
    let imageSize = image.size

    let widthRatio = viewSize.width / imageSize.width
    let heightRatio = viewSize.height / imageSize.height
    let scaledRatio = min(widthRatio, heightRatio)

    let scaleTransform = CGAffineTransform(scaleX: scaledRatio,
                                           y: scaledRatio)
    let scaledImageSize = imageSize.applying(scaleTransform)

    let imageX = (viewSize.width - scaledImageSize.width) / 2
    let imageY = (viewSize.height - scaledImageSize.height) / 2
    let imageLocationTransform = CGAffineTransform(
      translationX: imageX, y: imageY)

    let uiTransform = CGAffineTransform(scaleX: 1, y: -1)
      .translatedBy(x: 0, y: -imageSize.height)

    for face in observations {
      // 2
      let observedFaceBox = face.boundingBox

      let faceBox = observedFaceBox
        .scaled(to: imageSize)
        .applying(uiTransform)
        .applying(scaleTransform)
        .applying(imageLocationTransform)

      var leftEye: [CGPoint]?
      var rightEye: [CGPoint]?
      var median: [CGPoint]?
      if let landmarks = face.landmarks {
        leftEye = compute(feature: landmarks.leftEye, faceBox: faceBox)
        rightEye = compute(feature: landmarks.rightEye, faceBox: faceBox)
        median = compute(feature: landmarks.medianLine, faceBox: faceBox)
      }

      let face = FaceDimensions(faceRect: faceBox,
                                leftEye: leftEye,
                                rightEye: rightEye,
                                median: median)
      faces.append(face)
    }
    // 4
    annotationView.faces = faces
    annotationView.setNeedsDisplay()
  }

  private func compute(
    feature: VNFaceLandmarkRegion2D?,
    faceBox: CGRect) -> [CGPoint]? {

    guard let feature = feature else {
      return nil

    }
    var drawPoints: [CGPoint] = []
    for point in feature.normalizedPoints {
      let cgPoint = CGPoint(x: CGFloat(point.x),
                            y: CGFloat(1 - point.y))

      let scale = CGAffineTransform(scaleX: faceBox.width,
                                    y: faceBox.height)
      let translation = CGAffineTransform(
        translationX: faceBox.origin.x,
        y: faceBox.origin.y)
      let adjustedPoint = cgPoint.applying(scale)
        .applying(translation)
      drawPoints.append(adjustedPoint)
    }
    return drawPoints
  }

  func handleClassification(request: VNRequest, error: Error?) {
    guard let observations = request.results
      as? [VNClassificationObservation] else {
        print("unexpected result type from VNCoreMLRequest")
        return
    }
    guard let bestResult = observations.first else {
      print("Did not a valid classification")
      return
    }

    DispatchQueue.main.async {
      let scene = SceneType(classification: bestResult.identifier)
      self.annotationView.classification = scene
      print("Scene: '\(bestResult.identifier)'"
        + "\(bestResult.confidence)%")
    }
  }
}
