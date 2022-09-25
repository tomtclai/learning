

import XCTest

class PetSaveUITests: XCTestCase {
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }

  func testExample() throws {
    let app = XCUIApplication()
    app.launch()
  }

  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
}
