/*
* Copyright (c) 2014-present Razeware LLC
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
import QuartzCore

// A delay function
func delay(seconds: Double, completion: @escaping ()-> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

enum AnimationDirection: Int {
  case positive = 1
  case negative = -1
}

class ViewController: UIViewController {
  
  @IBOutlet var bgImageView: UIImageView!
  
  @IBOutlet var summaryIcon: UIImageView!
  @IBOutlet var summary: UILabel!
  
  @IBOutlet var flightNr: UILabel!
  @IBOutlet var gateNr: UILabel!
  @IBOutlet var departingFrom: UILabel!
  @IBOutlet var arrivingTo: UILabel!
  @IBOutlet var planeImage: UIImageView!
  
  @IBOutlet var flightStatus: UILabel!
  @IBOutlet var statusBanner: UIImageView!
  
  var snowView: SnowView!
  
  //MARK: view controller methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //adjust ui
    summary.addSubview(summaryIcon)
    summaryIcon.center.y = summary.frame.size.height/2
    
    //add the snow effect layer
    snowView = SnowView(frame: CGRect(x: -150, y:-100, width: 300, height: 50))
    let snowClipView = UIView(frame: view.frame.offsetBy(dx: 0, dy: 50))
    snowClipView.clipsToBounds = true
    snowClipView.addSubview(snowView)
    view.addSubview(snowClipView)
    
    //start rotating the flights
    changeFlight(to: londonToParis, animated: true)
  }
  
  //MARK: custom methods
  
  func changeFlight(to data: FlightData, animated: Bool = false) {
    
    // populate the UI with the next flight's data
    summary.text = data.summary
    if animated {
      fade(imageView: bgImageView, toImage: UIImage(named: data.weatherImageName)!, showEffects: data.showWeatherEffects)
      let direction: AnimationDirection = data.isTakingOff ? .positive : .negative
      transition(label: flightNr, toText: data.flightNr, direction: direction)
      transition(label: gateNr, toText: data.gateNr, direction: direction)
      transition(label: flightStatus, toText: data.flightStatus, direction: direction)
      transition(label: departingFrom, toText: data.departingFrom, direction: direction)
      transition(label: arrivingTo, toText: data.arrivingTo, direction: direction)
    } else {
      bgImageView.image = UIImage(named: data.weatherImageName)
      snowView.isHidden = !data.showWeatherEffects
      flightNr.text = data.flightNr
      gateNr.text = data.gateNr
      departingFrom.text = data.departingFrom
      arrivingTo.text = data.arrivingTo
      flightStatus.text = data.flightStatus
    }
    
    // schedule next flight
    delay(seconds: 3.0) {
      self.changeFlight(to: data.isTakingOff ? parisToRome : londonToParis, animated: animated)
    }
  }

  func fade(imageView: UIImageView, toImage image: UIImage, showEffects: Bool) {
    UIView.transition(with: imageView, duration: 0.5, options: [.transitionCrossDissolve], animations: {
      imageView.image = image
    }, completion: nil)

    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
      self.snowView.alpha = showEffects ? 1 : 0
    }, completion: nil)
  }

  func transition(label: UILabel, toText text: String, direction: AnimationDirection) {
    let auxLabel = UILabel(frame: label.frame)
    auxLabel.text = text
    auxLabel.font = label.font
    auxLabel.textAlignment = label.textAlignment
    auxLabel.textColor = label.textColor
    auxLabel.backgroundColor = label.backgroundColor


    let auxLabelOffset = CGFloat(direction.rawValue) * label.frame.size.height / 2.0

    auxLabel.transform = CGAffineTransform(translationX: 0, y: auxLabelOffset).scaledBy(x: 1.0, y: 0.1)

    label.superview?.addSubview(auxLabel)

    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
      auxLabel.transform = .identity
      label.transform = CGAffineTransform(translationX: 0, y: -auxLabelOffset).scaledBy(x: 1.0, y: 0.1)
    }) { _ in
      label.text = auxLabel.text
      label.transform = .identity
      auxLabel.removeFromSuperview()
    }
  }

}
