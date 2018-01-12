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

import ARKit

extension ARSCNView {
  func rayFromTapPoint(_ point: CGPoint) -> SCNVector3 {
    let pointWorldPosition = unprojectPoint(SCNVector3(x: Float(point.x), y: Float(point.y), z: 0))
    let cameraPosition = pointOfView!.position
    return (pointWorldPosition - cameraPosition).normalized()
  }
  
  func hitTestFeaturePoints(_ point: CGPoint, allowedAngleFromRay: Float) -> SCNVector3? {
    
    guard let featurePoints = session.currentFrame?.rawFeaturePoints else {
      return nil
    }
    
    var vectorsArray: [SCNVector3] = []
    
    for i in 0..<featurePoints.points.count {
      let feature = featurePoints.points[i]
      let featurePosition = SCNVector3(feature)
      vectorsArray.append(featurePosition)
    }
    
    return hitTestFeaturePoints(point, featurePoints: vectorsArray, allowedAngleFromRay: allowedAngleFromRay)
  }
  
  func hitTestFeaturePoints(_ point:CGPoint, featurePoints: [SCNVector3], allowedAngleFromRay: Float) -> SCNVector3? {
    
    let ray = rayFromTapPoint(point)
    let maxAngleRadians = allowedAngleFromRay / 180 * Float.pi
    
    var maxLength: Float = 0
    var currentFeaturePoint: SCNVector3? = nil
    
    for featurePosition in featurePoints {
      
      let cameraPosition = pointOfView!.position
      let cameraToFeaturePoint = (featurePosition - cameraPosition).normalized()
      let angleBetweenRayAndFeature = acos(ray.dot(vector: cameraToFeaturePoint))
      let cameraToFeaturePointLength = featurePosition.distanceTo(cameraPosition)
      
      let fitsInAngle = angleBetweenRayAndFeature <= maxAngleRadians
      let greaterLength = cameraToFeaturePointLength > maxLength
      let notTooClose = cameraToFeaturePointLength > 0.2
      
      if greaterLength && fitsInAngle && notTooClose {
        maxLength = cameraToFeaturePointLength
        currentFeaturePoint = featurePosition
      }
    }
    
    return currentFeaturePoint
  }
  
  func hitTestWithInfiniteHorizontalPlane(_ point: CGPoint, _ pointOnPlane: SCNVector3) -> SCNVector3? {
    
    let ray = rayFromTapPoint(point)
    return rayIntersectionWithHorizontalPlane(rayOrigin: pointOfView!.position, direction: ray, planeY: pointOnPlane.y)
  }
  
  func rayIntersectionWithHorizontalPlane(rayOrigin: SCNVector3, direction: SCNVector3, planeY: Float) -> SCNVector3? {
    let direction = direction.normalized()
    let dist = (planeY - rayOrigin.y) / direction.y
    return rayOrigin + (direction * dist)
  }
  
}
