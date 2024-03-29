/*
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

import XCTest
@testable import GooglyPuff

private let defaultTimeoutLengthInSeconds: Int = 10 // 10 Seconds

class GooglyPuffTests: XCTestCase {
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testLotsOfFacesImageURL() {
    downloadImageURLWithString(lotsOfFacesURLString)
  }

  func testSuccessKidImageURL() {
    downloadImageURLWithString(successKidURLString)
  }

  func testOverlyAttachedGirlfriendImageURL() {
    downloadImageURLWithString(overlyAttachedGirlfriendURLString)
  }

    // With semaphore
//    func downloadImageURLWithString(_ urlString: String) {
//        let url = URL(string: urlString)
//
//        let semaphore = DispatchSemaphore(value: 0) // no one can acces the semaphore without signaling (incrementing) it first
//        let _ = DownloadPhoto(url: url!) {
//            _, error in
//            if let error = error {
//                XCTFail("\(urlString) failed. \(error.localizedDescription)")
//            }
//            semaphore.signal()
//        }
//        let timeout = DispatchTime.now() + DispatchTimeInterval.seconds(defaultTimeoutLengthInSeconds)
//        if semaphore.wait(timeout: timeout) == .timedOut {
//            XCTFail("\(urlString) timed out")
//        }
//    }
    // with expectations
    func downloadImageURLWithString(_ urlString: String) {
        let url = URL(string: urlString)
        let downloadExpectation = expectation(description: "Image downloaded from \(urlString)")
        _ = DownloadPhoto(url: url!) {
            _, error in
            if let error = error {
                XCTFail("\(urlString) failed. \(error.localizedDescription)")
            }
            downloadExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
}
