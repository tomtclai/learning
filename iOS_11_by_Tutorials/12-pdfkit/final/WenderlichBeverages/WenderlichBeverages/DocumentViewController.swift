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

protocol DocumentViewControllerDelegate {
  func didSaveDocument()
}

class DocumentViewController: UIViewController {
  
  @IBOutlet weak var pdfView: PDFView!
  
  var document: PDFDocument?
  var addAnnotations = false
  var delegate: DocumentViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let document = document {
      if document.isEncrypted || document.isLocked {
        document.delegate = self
        if let page = document.page(at: 0) {
          for annotation in page.annotations {
            annotation.isReadOnly = true
          }
        }
      }
      pdfView.displayMode = .singlePageContinuous
      pdfView.backgroundColor =
        UIColor.lightGray.withAlphaComponent(0.25)
      pdfView.displaysPageBreaks = true
      pdfView.autoScales = true
      pdfView.document = document
      
      if addAnnotations {
        addContractAnnotations()
      } else {
        navigationItem.rightBarButtonItem = nil
      }
    }
  }
  
  @IBAction func saveAnnotations(_ sender: Any) {
    guard let document = document,
      let page = document.page(at: 0) else { return }
    
    // 1
    var contracteeName: String?
    for annotation in page.annotations {
      if annotation.fieldName == FieldNames.clearButton.rawValue {
        // 2
        page.removeAnnotation(annotation)
      } else if annotation.fieldName == FieldNames.name.rawValue {
        contracteeName = annotation.value(forAnnotationKey: .widgetValue) as? String
      }
    }
    if let name = contracteeName {
      // 3
      var displayName = name.replacingOccurrences(of: " ", with: "_")
      displayName += ".pdf"
      let savePath = FileUtilities.contractsDirectory()
        .appending("/\(displayName)")
      // 4
      document.write(to: URL(fileURLWithPath: savePath),
                     withOptions: [.ownerPasswordOption: "SoMuchSecurity"])
      delegate?.didSaveDocument()
      navigationController?.popViewController(animated: true)
    }
  }
  
}

extension DocumentViewController: PDFDocumentDelegate {
  func classForPage() -> AnyClass {
    return LockedMark.self
  }
}

enum FieldNames: String {
  case name
  case colaPrice
  case rrPrice
  case clearButton
}

extension DocumentViewController {
  func addContractAnnotations() {
    guard let page = document?.page(at: 0) else { return }
    let pageBounds = page.bounds(for: .cropBox)
    
    // 1. Add Name Box
    let textFieldNameBounds = CGRect(x: 128, y: pageBounds.size.height - 142, width: 230, height: 23)
    let textFieldName = textWidget(bounds: textFieldNameBounds, fieldName: FieldNames.name.rawValue)
    page.addAnnotation(textFieldName)
    
    // 2. Add Birthday Box
    let textFieldDateBounds = CGRect(x: 198, y: pageBounds.size.height - 166, width: 160, height: 23)
    let textFieldDate = textWidget(bounds: textFieldDateBounds, fieldName: nil)
    textFieldDate.maximumLength = 10
    textFieldDate.hasComb = true
    page.addAnnotation(textFieldDate)
    
    // 3. Add Price Boxes
    let textFieldPriceColaBounds = CGRect(x: 182, y: pageBounds.size.height - 190, width: 176, height: 23)
    let textFieldPriceCola = textWidget(bounds: textFieldPriceColaBounds, fieldName: FieldNames.colaPrice.rawValue)
    page.addAnnotation(textFieldPriceCola)
    
    let textFieldPriceRRBounds = CGRect(x: 200, y: pageBounds.size.height - 214, width: 158, height: 23)
    let textFieldPriceRR = textWidget(bounds: textFieldPriceRRBounds, fieldName: FieldNames.rrPrice.rawValue)
    page.addAnnotation(textFieldPriceRR)
    
    // 4. Add Delivery Day Radio Buttons
    let buttonSize = CGSize(width: 18, height: 18)
    let buttonYOrigin = pageBounds.size.height - 285
    let buttonFieldName = "WEEK"
    
    let sundayButton = radioButton(
      fieldName: buttonFieldName,
      startingState: "Sun",
      bounds: CGRect(origin: CGPoint(x: 105, y: buttonYOrigin), size: buttonSize))
    page.addAnnotation(sundayButton)
    
    let mondayButton = radioButton(
      fieldName: buttonFieldName,
      startingState: "Mon",
      bounds: CGRect(origin: CGPoint(x: 160, y: buttonYOrigin), size: buttonSize))
    page.addAnnotation(mondayButton)
    
    let tuesdayButton = radioButton(
      fieldName: buttonFieldName,
      startingState: "Tue",
      bounds: CGRect(origin: CGPoint(x: 215, y: buttonYOrigin), size: buttonSize))
    page.addAnnotation(tuesdayButton)
    
    let wednesdayButton = radioButton(
      fieldName: buttonFieldName,
      startingState: "Wed",
      bounds: CGRect(origin: CGPoint(x: 267, y: buttonYOrigin), size: buttonSize))
    page.addAnnotation(wednesdayButton)
    
    let thursdayButton = radioButton(
      fieldName: buttonFieldName,
      startingState: "Thr",
      bounds: CGRect(origin: CGPoint(x: 320, y: buttonYOrigin), size: buttonSize))
    page.addAnnotation(thursdayButton)
    
    let fridayButton = radioButton(
      fieldName: buttonFieldName,
      startingState: "Fri",
      bounds: CGRect(origin: CGPoint(x: 370, y: buttonYOrigin), size: buttonSize))
    page.addAnnotation(fridayButton)
    
    let saturdayButton = radioButton(
      fieldName: buttonFieldName,
      startingState: "Sat",
      bounds: CGRect(origin: CGPoint(x: 420, y: buttonYOrigin), size: buttonSize))
    page.addAnnotation(saturdayButton)
    
    // 5. Add Agree Check Box
    let checkBoxAgreeBounds = CGRect(x: 75, y: pageBounds.size.height - 375, width: 18, height: 18)
    let checkBox = PDFAnnotation(bounds: checkBoxAgreeBounds, forType: .widget, withProperties: nil)
    checkBox.widgetFieldType = .button
    checkBox.widgetControlType = .checkBoxControl
    page.addAnnotation(checkBox)
    
    // 6. Add Clear Button
    let clearButtonBounds = CGRect(x: 75, y: pageBounds.size.height - 450, width: 106, height: 32)
    let clearButton = PDFAnnotation(bounds: clearButtonBounds, forType: .widget, withProperties: nil)
    clearButton.widgetFieldType = .button
    clearButton.widgetControlType = .pushButtonControl
    clearButton.caption = "Clear"
    clearButton.fieldName = FieldNames.clearButton.rawValue
    page.addAnnotation(clearButton)
    
    let resetFormAction = PDFActionResetForm()
    resetFormAction.fields = [FieldNames.colaPrice.rawValue, FieldNames.rrPrice.rawValue]
    resetFormAction.fieldsIncludedAreCleared = false
    clearButton.action = resetFormAction
  }
  
  func textWidget(bounds: CGRect, fieldName: String?) -> PDFAnnotation {
    let textWidget = PDFAnnotation(bounds: bounds, forType: .widget, withProperties: nil)
    textWidget.widgetFieldType = .text
    textWidget.font = UIFont.systemFont(ofSize: 18)
    textWidget.fieldName = fieldName
    return textWidget
  }
  
  func radioButton(fieldName: String, startingState: String, bounds: CGRect) -> PDFAnnotation {
    let radioButton = PDFAnnotation(bounds: bounds, forType: .widget, withProperties: nil)
    radioButton.widgetFieldType = .button
    radioButton.widgetControlType = .radioButtonControl
    radioButton.fieldName = fieldName
    radioButton.buttonWidgetStateString = startingState
    return radioButton
  }
}
