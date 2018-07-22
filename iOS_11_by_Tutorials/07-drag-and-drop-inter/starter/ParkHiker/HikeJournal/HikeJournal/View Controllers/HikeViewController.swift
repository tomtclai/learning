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
import Park
import MapKit

class HikeViewController: UIViewController {
  public var park: Park?
  var startingMapRegion: MKCoordinateRegion?
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var hikeNotesTextView: UITextView!
  @IBOutlet weak var leftImageView: UIImageView!
  @IBOutlet weak var rightImageView: UIImageView!
  @IBOutlet weak var clearButton: UIButton!
  @IBOutlet weak var stackView: UIStackView!

  var imageViews: [UIImageView]?

  var images: [UIImage] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    imageViews = [leftImageView, rightImageView]
    startingMapRegion = mapView.region
    hikeNotesTextView.textDropDelegate = self
    displayPark()
  }

  @IBAction func clearButtonPressed(_ sender: Any) {
    park = nil
    hikeNotesTextView.text = ""
    displayPark()
  }

  func displayPark() {
    guard let park = park else {
      nameLabel.text = " "
      if let region = startingMapRegion {
        mapView.setRegion(region, animated: false)
      }
      images.removeAll()
      updateImages()
      return
    }

    nameLabel.text = park.name

    let coordinate = CLLocationCoordinate2D(latitude: park.latitude, longitude: park.longitude)
    let mapRect = MKCoordinateRegionMakeWithDistance(coordinate, 100000, 100000)
    mapView.setRegion(mapRect, animated: false)
    images.removeAll()
    addImage(park.image)
  }

  func updateImages() {
    guard let imageViews = imageViews, images.count < 3
      else { return }

    var i = 0
    imageViews.forEach {
      $0.image = (i < images.count) ? images[i] : nil
      i += 1
    }
  }

  func addImage(_ image: UIImage) {
    images.insert(image, at: 0)
    images = Array(images.prefix(2))
    updateImages()
  }
}

// MARK: UITextDropDelegate
// This code prevents the UITextView from intercepting drops made
// on Hike Journal
extension HikeViewController: UITextDropDelegate {
  func textDroppableView(_ textDroppableView: UIView & UITextDroppable, proposalForDrop drop: UITextDropRequest) -> UITextDropProposal {
    return UITextDropProposal(operation: .forbidden)
  }
}
