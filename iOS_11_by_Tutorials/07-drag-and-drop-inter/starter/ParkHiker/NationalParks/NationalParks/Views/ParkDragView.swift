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

public class ParkDragView: UIView {
  
  public init (_ image: UIImage, name: String) {
    super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 240))
    let imageView = UIImageView(image: image)
    let nameLabel = UILabel()
    nameLabel.font = UIFont.systemFont(ofSize: 22)
    
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: 180),
      imageView.heightAnchor.constraint(equalToConstant: 180)
      ])
    
    nameLabel.text = name
    
    let stackView = UIStackView(arrangedSubviews: [nameLabel, imageView])
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.clipsToBounds = true
    let stackBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y,
                             width: bounds.width, height: bounds.height - 20)
    stackView.frame = stackBounds
    
    addSubview(stackView)
  }
  
  public required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
}

