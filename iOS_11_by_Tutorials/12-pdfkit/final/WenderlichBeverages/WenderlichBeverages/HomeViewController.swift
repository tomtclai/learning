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
import PDFKit

class HomeViewController: UIViewController {

  @IBOutlet weak var documentsStackView: UIStackView!
  @IBOutlet weak var imageView1: UIImageView!
  @IBOutlet weak var imageView2: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    preloadDocuments()
    loadDocumentThumbnails()
  }

  private func preloadDocuments() {
    for document in SalesDocument.allDocuments() {
      let documentPath = FileUtilities.documentsDirectory().appending("/\(document.nameWithExtension())")
      if !FileManager.default.fileExists(atPath: documentPath) {
        guard let pdfPath = Bundle.main.path(forResource: document.rawValue, ofType: "pdf"),
          let pdfDocument = PDFDocument(url: URL(fileURLWithPath: pdfPath)) else { continue }
        pdfDocument.write(toFile: documentPath)
      }
    }
  }

  private func loadDocumentThumbnails() {
    let document1Path = FileUtilities.documentsDirectory().appending("/\(SalesDocument.wbCola.nameWithExtension())")
    let colaDocument = PDFDocument(url: URL(fileURLWithPath: document1Path))
    let document2Path = FileUtilities.documentsDirectory().appending("/\(SalesDocument.wbRaysReserve.nameWithExtension())")
    let rrDocument = PDFDocument(url: URL(fileURLWithPath: document2Path))
    imageView1.image = thumbnailImageForPDFDocument(document: colaDocument)
    imageView2.image = thumbnailImageForPDFDocument(document: rrDocument)
  }

  private func thumbnailImageForPDFDocument(document: PDFDocument?) -> UIImage? {
    guard let document = document,
      let page = document.page(at: 0) else { return nil }
    return page.thumbnail(of: CGSize(width: documentsStackView.frame.size.width, height: documentsStackView.frame.size.height / 2), for: .cropBox)
  }

  @IBAction func showDocument(_ sender: UITapGestureRecognizer) {
    guard let view = sender.view as? UIImageView else { return }
    let document: String
    if view === imageView1 {
      document = SalesDocument.wbCola.nameWithExtension()
    } else {
      document = SalesDocument.wbRaysReserve.nameWithExtension()
    }
    let urlPath = URL(fileURLWithPath: FileUtilities.documentsDirectory().appending("/\(document)"))
    let pdfDocument = PDFDocument(url: urlPath)
    performSegue(withIdentifier: SegueIdentifiers.showDocumentSegue.rawValue, sender: pdfDocument)
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    if identifier == SegueIdentifiers.showDocumentSegue.rawValue {
      if let document = sender as? PDFDocument,
        let upcoming = segue.destination as? DocumentViewController {
        upcoming.document = document
        upcoming.title = "Sales Document"
      }
    }
  }

}
