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

class ContractsTableViewController: UITableViewController {
  
  var documents: [String]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadDocuments()
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    if identifier == SegueIdentifiers.newContractSegue.rawValue {
      guard let pdfPath = Bundle.main.path(forResource: ContractDocument.contractTemplate.rawValue, ofType: "pdf"),
        let upcoming = segue.destination as? DocumentViewController else {
          return
      }
      upcoming.document = PDFDocument(url: URL(fileURLWithPath: pdfPath))
      upcoming.title = "New Contract"
      upcoming.addAnnotations = true
      upcoming.delegate = self
    } else if identifier == SegueIdentifiers.currentContract.rawValue {
      guard let upcoming = segue.destination as? DocumentViewController,
        let cell = sender as? UITableViewCell,
        let indexPath = tableView.indexPath(for: cell),
        let documents = documents else { return }
      let document = documents[indexPath.row]
      upcoming.addAnnotations = false
      upcoming.title = document
      let path = FileUtilities.contractsDirectory().appending("/\(document)")
      upcoming.document = PDFDocument(url: URL(fileURLWithPath: path))
      upcoming.delegate = self
    }
  }
  
  func loadDocuments() {
    documents = try? FileManager.default.contentsOfDirectory(atPath: FileUtilities.contractsDirectory())
    documents = documents?.filter { path -> Bool in
      return (path as NSString).pathExtension == "pdf"
    }
    tableView.reloadData()
  }
}

extension ContractsTableViewController: DocumentViewControllerDelegate {
  func didSaveDocument() {
    loadDocuments()
  }
}

// MARK: - Table view data source
extension ContractsTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let documents = documents else { return 0 }
    return documents.count
  }
}

// MARK: - Table view delegate
extension ContractsTableViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    if let documents = documents {
      let document = documents[indexPath.row]
      cell.textLabel?.text = (document as NSString).lastPathComponent
    }
    return cell
  }
}

