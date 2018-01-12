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
import ARKit

enum FunctionMode {
  case none
  case placeObject(String)
  case measure
}

class HomeHeroViewController: UIViewController {
  
  @IBOutlet var sceneView: ARSCNView!
  @IBOutlet weak var chairButton: UIButton!
  @IBOutlet weak var candleButton: UIButton!
  @IBOutlet weak var measureButton: UIButton!
  @IBOutlet weak var vaseButton: UIButton!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var crosshair: UIView!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var trackingInfo: UILabel!
  
  var currentMode: FunctionMode = .none
  var objects: [SCNNode] = []
  var measuringNodes: [SCNNode] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    trackingInfo.text = ""
    messageLabel.text = ""
    distanceLabel.isHidden = true
    selectVase()
  }
  
  @IBAction func didTapChair(_ sender: Any) {
    currentMode = .placeObject("Models.scnassets/chair/chair.scn")
    selectButton(chairButton)
  }
  
  @IBAction func didTapCandle(_ sender: Any) {
    currentMode = .placeObject("Models.scnassets/candle/candle.scn")
    selectButton(candleButton)
  }
  
  @IBAction func didTapMeasure(_ sender: Any) {
    currentMode = .measure
    selectButton(measureButton)
  }
  
  @IBAction func didTapVase(_ sender: Any) {
    selectVase()
  }
  
  @IBAction func didTapReset(_ sender: Any) {
    removeAllObjects()
    distanceLabel.text = ""
  }
  
  func selectVase() {
    currentMode = .placeObject("Models.scnassets/vase/vase.scn")
    selectButton(vaseButton)
  }
  
  func selectButton(_ button: UIButton) {
    unselectAllButtons()
    button.isSelected = true
  }
  
  func unselectAllButtons() {
    [chairButton, candleButton, measureButton, vaseButton].forEach {
      $0?.isSelected = false
    }
  }
  
  func removeAllObjects() {
    for object in objects {
      object.removeFromParentNode()
    }
    
    objects = []
  }
}
