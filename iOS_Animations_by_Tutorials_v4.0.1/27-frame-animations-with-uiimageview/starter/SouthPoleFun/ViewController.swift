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

class ViewController: UIViewController {
  
  @IBOutlet var penguin: UIImageView!
  @IBOutlet var slideButton: UIButton!
  
  var isLookingRight: Bool = true {
    didSet {
      let xScale: CGFloat = isLookingRight ? 1 : -1
      penguin.transform = CGAffineTransform(scaleX: xScale, y: 1)
      slideButton.transform = penguin.transform
    }
  }
  var penguinY: CGFloat = 0.0
  
  var walkSize: CGSize = CGSize.zero
  var slideSize: CGSize = CGSize.zero
  
  let animationDuration = 1.0
  
  var walkFrames = [#imageLiteral(resourceName: "walk01"), #imageLiteral(resourceName: "walk02"), #imageLiteral(resourceName: "walk03"), #imageLiteral(resourceName: "walk04")]
  
  var slideFrames = [#imageLiteral(resourceName: "slide01"), #imageLiteral(resourceName: "slide02")]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //grab the sizes of the different sequences
    walkSize = walkFrames[0].size
    print(walkSize)
    slideSize = slideFrames[0].size
    
    //setup the animation
    penguinY = penguin.frame.origin.y

    loadWalkAnimation()
    
  }
  
  func loadWalkAnimation() {
    penguin.animationImages = walkFrames
    penguin.animationDuration = animationDuration / 3
    penguin.animationRepeatCount = 3
  }
  
  func loadSlideAnimation() {
    
  }
  
  @IBAction func actionLeft(_ sender: AnyObject) {
    isLookingRight = false
    penguinWalk(translation: -walkSize.width)
  }

  func penguinWalk(translation: CGFloat) {
    penguin.startAnimating()
    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
      self.penguin.center.x += translation
    }, completion: nil)
  }

  @IBAction func actionRight(_ sender: AnyObject) {
    isLookingRight = true
    penguinWalk(translation: +walkSize.width)
  }
  
  @IBAction func actionSlide(_ sender: AnyObject) {
    
  }
}

