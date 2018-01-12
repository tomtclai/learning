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
  
  // MARK: - Properties
  
  @IBOutlet var sceneView: ARSCNView!
  @IBOutlet weak var chairButton: UIButton!
  @IBOutlet weak var candleButton: UIButton!
  @IBOutlet weak var measureButton: UIButton!
  @IBOutlet weak var vaseButton: UIButton!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var crosshair: UIView!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var trackingInfo: UILabel!
  
  var lastHighQualityFeaturePoint: SCNVector3?
  var currentMode: FunctionMode = .none
  var measuringNodes: [SCNNode] = []
  var objects: [SCNNode] = []
  
  // MARK: - UIViewController methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    runSession()
    trackingInfo.text = ""
    messageLabel.text = ""
    distanceLabel.isHidden = true
    selectVase()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    if let hit = sceneView.hitTest(viewCenter, types: [.existingPlaneUsingExtent]).first {
      sceneView.session.add(anchor: ARAnchor(transform: hit.worldTransform))
      return
    }
    
    if let highQualityFeature = lastHighQualityFeaturePoint {
      if let point = sceneView.hitTestWithInfiniteHorizontalPlane(viewCenter, highQualityFeature) {
        let matrix =  SCNMatrix4MakeTranslation(point.x, point.y, point.z)
        sceneView.session.add(anchor: ARAnchor(transform: float4x4(matrix)))
        return
      }
    }
    
    showMessage("Please move around with the camera", label: messageLabel, seconds: 2)
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
}

// MARK: - ARSCNViewDelegate

extension HomeHeroViewController: ARSCNViewDelegate {
  
  func session(_ session: ARSession, didFailWithError error: Error) {
    showMessage(error.localizedDescription, label: messageLabel, seconds: 2)
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
    
    showMessage("Session interrupted", label: messageLabel, seconds: 2)
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
    showMessage("Session resumed", label: messageLabel, seconds: 2)
    removeAllObjects()
    runSession()
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    
    DispatchQueue.main.async {
      
      if let planeAnchor = anchor as? ARPlaneAnchor {
        #if DEBUG
          let planeNode = createPlaneNode(center: planeAnchor.center, extent: planeAnchor.extent)
          node.addChildNode(planeNode)
        #endif
      } else {
        switch self.currentMode {
          
        case .none: break;
          
        case .placeObject(let name):
          
          let modelClone = nodeWithModelName(name)
          self.objects.append(modelClone)
          modelClone.position = SCNVector3Zero
          node.addChildNode(modelClone)
          
        case .measure:
          
          let sphereNode = createSphereNode(radius: 0.02)
          self.objects.append(sphereNode)
          sphereNode.position = SCNVector3Zero
          node.addChildNode(sphereNode)
          self.measuringNodes.append(node)
        }
      }
    }
  }
  
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    
    DispatchQueue.main.async {
      if let planeAnchor = anchor as? ARPlaneAnchor {
        updatePlaneNode(node.childNodes[0], center: planeAnchor.center, extent: planeAnchor.extent)
      } else {
        self.updateMeasuringNodes()
      }
    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    
    DispatchQueue.main.async {
      
      self.updateTrackingInfo()
      
      if let highQualityFeature = self.sceneView.hitTestFeaturePoints(self.viewCenter, allowedAngleFromRay: 8) {
        self.lastHighQualityFeaturePoint = highQualityFeature
      }
      
      if let _ = self.sceneView.hitTest(self.viewCenter, types: [.existingPlaneUsingExtent]).first {
        self.crosshair.backgroundColor = UIColor.green
      } else {
        self.crosshair.backgroundColor = UIColor.init(white: 0.34, alpha: 1)
      }
    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    guard anchor is ARPlaneAnchor else { return }
    removeChildren(inNode: node)
  }
}

// MARK: - Private methods

private extension HomeHeroViewController {
  
  func updateMeasuringNodes() {
    guard measuringNodes.count > 1 else {
      return
    }
    
    let firstNode = measuringNodes[0]
    let secondNode = measuringNodes[1]
    
    let showMeasuring = self.measuringNodes.count == 2
    
    distanceLabel.isHidden = !showMeasuring
    
    if showMeasuring {
      measure(fromNode: firstNode, toNode: secondNode)
    } else if measuringNodes.count > 2  {
      firstNode.removeFromParentNode()
      secondNode.removeFromParentNode()
      measuringNodes.removeFirst(2)
      for node in sceneView.scene.rootNode.childNodes {
        if node.name == "MeasuringLine" {
          node.removeFromParentNode()
        }
      }
    }
  }
  
  func measure(fromNode: SCNNode, toNode: SCNNode) {
    let measuringLineNode = createLineNode(fromNode: fromNode, toNode: toNode)
    measuringLineNode.name = "MeasuringLine"
    sceneView.scene.rootNode.addChildNode(measuringLineNode)
    objects.append(measuringLineNode)
    let dist = fromNode.position.distanceTo(toNode.position)
    let measurementValue = String(format: "%.2f", dist)
    distanceLabel.text = "Distance: \(measurementValue) m"
  }
  
  func runSession() {
    sceneView.delegate = self
    
    let configuration = ARWorldTrackingConfiguration()
    
    configuration.planeDetection = .horizontal
    configuration.isLightEstimationEnabled = true
    sceneView.session.run(configuration)
    
    #if DEBUG
      sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
    #endif
  }
  
  func updateTrackingInfo() {
    guard let frame = sceneView.session.currentFrame else {
      return
    }
    
    switch frame.camera.trackingState {
    case .limited(let reason):
      switch reason {
      case .excessiveMotion:
        trackingInfo.text = "Limited Tracking: Excessive Motion"
      case .insufficientFeatures:
        trackingInfo.text = "Limited Tracking: Insufficient Details"
      default:
        trackingInfo.text = "Limited Tracking"
      }
    default: trackingInfo.text = ""
    }
    
    guard let lightEstimate = frame.lightEstimate?.ambientIntensity else {
      return
    }
    
    if lightEstimate < 100 {
      trackingInfo.text = "Limited Tracking: Too Dark"
    }
  }
  
  func removeAllObjects() {
    for object in objects {
      object.removeFromParentNode()
    }
    
    objects = []
  }
  
}
