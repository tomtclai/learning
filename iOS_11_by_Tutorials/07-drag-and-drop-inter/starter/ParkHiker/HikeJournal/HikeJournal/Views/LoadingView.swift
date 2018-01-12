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


class LoadingView: UIView {
  var progress: Progress!
  var progressLabel: UILabel!
  let fractionCompletedKey = "fractionCompleted"
  
  init(_ frame: CGRect, progress: Progress) {
    super.init(frame: frame)
    
    self.progress = progress
    progress.addObserver(self, forKeyPath: fractionCompletedKey, options: .new, context: nil)
    
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(blurView)
    
    let layoutConstraints = [NSLayoutConstraint(item: blurView,
                                                attribute: .height, relatedBy: .equal, toItem: self,
                                                attribute: .height, multiplier: 1, constant: 0),
                             NSLayoutConstraint(item: blurView,
                                                attribute: .width, relatedBy: .equal, toItem: self,
                                                attribute: .width, multiplier: 1, constant: 0)]
    NSLayoutConstraint.activate(layoutConstraints)
    
    progressLabel = UILabel(frame: bounds)
    progressLabel.text = "0%"
    progressLabel.font = UIFont.systemFont(ofSize: 60)
    progressLabel.textAlignment = .center
    addSubview(progressLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    guard let progress = object as? Progress else { return }
    let percentComplete = Int(round(progress.fractionCompleted * 100))
    
    DispatchQueue.main.async {
      self.progressLabel.text = "\(percentComplete)%"
    }
  }
  
  deinit {
    progress.removeObserver(self, forKeyPath: fractionCompletedKey)
  }
}
