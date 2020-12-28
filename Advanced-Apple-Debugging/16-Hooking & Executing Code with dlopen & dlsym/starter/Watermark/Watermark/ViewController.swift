/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import HookingSwift

class ViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var imageView: UIImageView!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    let imageGenerator = CopyrightImageGenerator()
    imageView.image = imageGenerator.watermarkedImage

    if let handle = dlopen("./Frameworks/HookingSwift.framework/HookingSwift", RTLD_NOW) {
      let sym = dlsym(handle, "$s12HookingSwift23CopyrightImageGeneratorC08originalD033_71AD57F3ABD678B113CF3AD05D01FF41LLSo7UIImageCSgvg")!
      print("\(sym)")

      typealias privateMethodAlias = @convention(c) (Any) -> UIImage?
      /*This declares the type of function that is syntactically equivalent to the Swift function for the originalImage property getter. There’s something very important to notice here. privateMethodAlias is designed so it takes one parameter type of Any, but the actual Swift function expects no parameters. Why is this?

      It’s due to the fact that by looking at the assembly to this method, the reference to self is expected in the RDI register. This means you need to supply the instance of the class as the first parameter into the function to trick this C function into thinking it’s a Swift method. If you don’t do this, there’s a chance the application will crash!*/

      let originalImageFunction = unsafeBitCast(sym, to: privateMethodAlias.self)
      let originalImage = originalImageFunction(imageGenerator)
      /* You’re executing the method and supplying the instance of the class as the first and only parameter to the function. This will cause the RDI register to be properly set to the instance of the class. It’ll return the original image without the watermark. */
      self.imageView.image = originalImage
    }

  }
}
