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

class ParkViewController: UIViewController {
  public var park: Park?
  public var pageIndex: Int?
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var summaryTextView: UITextView!
  @IBOutlet weak var addresslabel: UILabel!
  @IBOutlet weak var stackView: UIStackView!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    guard let park = park else { return }
    nameLabel.text! = park.name
    imageView.image = park.image
    summaryTextView.text! = park.summary
    addresslabel.text! = "\(park.latitude)°N, \(park.longitude)°W"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.isUserInteractionEnabled = true
    let dragInteraction = UIDragInteraction(delegate: self)
    stackView.addInteraction(dragInteraction)
  }
}

// MARK: UIDragInteractionDelegate
extension ParkViewController: UIDragInteractionDelegate {
  func dragInteraction(_ interaction: UIDragInteraction,
                       itemsForBeginning session: UIDragSession) -> [UIDragItem] {
    guard let park = park else { return [] }
    
    let provider = NSItemProvider(object: park)
    let dragItem = UIDragItem(itemProvider: provider)
    return [dragItem]
  }
  
  func dragInteraction(_ interaction: UIDragInteraction,
                       previewForLifting item: UIDragItem,
                       session: UIDragSession) -> UITargetedDragPreview? {

      guard let park = park, let dragView = interaction.view
        else { return UITargetedDragPreview(view: interaction.view!) }
      
      let parkView = ParkDragView(park.image, name: park.name)
      let parameters = UIDragPreviewParameters()
      parameters.visiblePath =
        UIBezierPath(roundedRect: parkView.bounds, cornerRadius: 20)
      
      let dragPoint = session.location(in: dragView)
      let target = UIDragPreviewTarget(container: dragView, center: dragPoint)
      return UITargetedDragPreview(view: parkView,
                                   parameters: parameters,
                                   target: target)
  }
  
  func dragInteraction(_ interaction: UIDragInteraction,
                       willAnimateLiftWith animator: UIDragAnimating,
                       session: UIDragSession) {
    animator.addAnimations {
      self.imageView.alpha = 0.25
    }
  }
  
  func dragInteraction(_ interaction: UIDragInteraction,
                       session: UIDragSession,
                       didEndWith operation: UIDropOperation) {
    if operation == .copy {
      imageView.alpha = 1.0
    }
  }
  
  func dragInteraction(_ interaction: UIDragInteraction,
                       item: UIDragItem,
                       willAnimateCancelWith animator: UIDragAnimating) {
    animator.addAnimations {
      self.imageView.alpha = 1.0
    }
  }
  
  func dragInteraction(_ interaction: UIDragInteraction,
                       previewForCancelling item: UIDragItem,
                       withDefault defaultPreview: UITargetedDragPreview)
    -> UITargetedDragPreview? {
      guard let superview = imageView.superview
        else { return defaultPreview }
      
      let target = UIDragPreviewTarget(container: superview,
                                       center: imageView.center)
      return UITargetedDragPreview(view: imageView,
                                   parameters: UIDragPreviewParameters(),
                                   target: target)
  }
  
  func dragInteraction(_ interaction: UIDragInteraction,
                       sessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool
  {
    return false
  }
}


