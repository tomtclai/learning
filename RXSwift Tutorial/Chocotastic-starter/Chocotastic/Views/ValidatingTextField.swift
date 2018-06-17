/**
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

class ValidatingTextField: UITextField {
  
  var valid: Bool = false {
    didSet {
      configureForValid()
    }
  }
  
  var hasBeenExited: Bool = false {
    didSet {
      configureForValid()
    }
  }
  
  func commonInit() {
    configureForValid()
  }
  
  //Yeah, totally required.
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func resignFirstResponder() -> Bool {
    hasBeenExited = true
    return super.resignFirstResponder()
  }
  
  private func configureForValid() {
    if !valid && hasBeenExited {
      //Only color the background if the user has tried to
      //input things at least once.
      self.backgroundColor = .red
    } else {
      self.backgroundColor = .clear
    }
  }
}

