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

import Foundation
import StoreKit

private let developerTokenServerUrl = URL(string: "https://example.com/devtoken")!

private class MockURLProtocol: URLProtocol {
  static var fakeResponse = ""  // Your developer token will go here
  static var fakeHeaders: [String: String] = [:]
  static var fakeStatusCode = 200
  static var urlToHandle: URL?

  override func startLoading() {
    let client = self.client!
    let response = HTTPURLResponse(url: request.url!, statusCode: MockURLProtocol.fakeStatusCode, httpVersion: "HTTP/1.1", headerFields: MockURLProtocol.fakeHeaders)!
    client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    client.urlProtocol(self, didLoad: MockURLProtocol.fakeResponse.data(using: .utf8)!)
    client.urlProtocolDidFinishLoading(self)
  }

  override func stopLoading() {
  }

  override class func canInit(with request: URLRequest) -> Bool {
    return (request.url == developerTokenServerUrl)
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
}

class RequestCapabilitiesOperation: AsyncOperation {
  var capabilities: SKCloudServiceCapability?
  override func main() {
    SKCloudServiceController().requestCapabilities { result, error in
      self.capabilities = result
      self.state = .finished
    }
  }
}

class DownloadDeveloperTokenOperation: AsyncOperation {
  var developerToken: String?
  override func main() {
    // This is just here to simulate downloading the token from a server
    URLProtocol.registerClass(MockURLProtocol.self)
    let task = URLSession.shared.dataTask(with: developerTokenServerUrl) { data, response, error in
      guard let data = data else {
        self.state = .finished
        return
      }
      self.developerToken = String(data: data, encoding: .utf8)
      self.state = .finished
    }
    task.resume()
  }
}

class RequestCountryCodeOperation: AsyncOperation {
  var countryCode: String?
  override func main() {
    SKCloudServiceController().requestStorefrontCountryCode { result, error in
      self.countryCode = result
      self.state = .finished
    }
  }
}

class DownloadUserTokenOperation: AsyncOperation {
  var userToken: String?
  private let userTokenKey = "userTokenKey"

  override func main() {
    if let cachedToken = UserDefaults.standard.string(forKey: userTokenKey) {
      self.userToken = cachedToken
      self.state = .finished
    } else {
      guard let developerToken = AuthorizationManager.downloadDeveloperTokenOperation.developerToken else {
        self.state = .finished
        return
      }
      SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken) { result, error in
        guard error == nil else {
          print("Error getting user token: \(error!.localizedDescription)")
          self.state = .finished
          return
        }
        self.userToken = result
        UserDefaults.standard.set(result, forKey: self.userTokenKey)
        self.state = .finished
      }
    }
  }
}

class AuthorizationManager {
  static func authorize(completionIfAuthorized authorizedCompletion: @escaping () -> Void, ifUnauthorized unauthorizedCompletion: @escaping () -> Void) {
    SKCloudServiceController.requestAuthorization { authorizationStatus in
      switch authorizationStatus {
      case .authorized:
        DispatchQueue.main.async {
          authorizedCompletion()
        }
      case .restricted, .denied:
        DispatchQueue.main.async {
          unauthorizedCompletion()
        }
      default:
        break
      }
    }
  }

  private static let capabilitiesOperation = RequestCapabilitiesOperation()

  private static let capabilitesQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.addOperation(capabilitiesOperation)
    let subscribeOperation = BlockOperation {
      guard let capabilities = capabilitiesOperation.capabilities else { return }
      if capabilities.contains(.musicCatalogPlayback) == false, capabilities.contains(.musicCatalogSubscriptionEligible) {
        DispatchQueue.main.async {
          let signupController = SKCloudServiceSetupViewController()
          signupController.load(options: [.action: SKCloudServiceSetupAction.subscribe]) { isLoaded, error in
            guard error == nil else {
              print("Error loading subscription view: \(error!.localizedDescription)")
              return
            }
            if isLoaded {
              signupController.show(animated: true)
            }
          }
        }
      }
    }
    subscribeOperation.addDependency(capabilitiesOperation)
    queue.addOperation(subscribeOperation)
    return queue
  }()

  static func withCapabilities(completion: @escaping (SKCloudServiceCapability) -> Void) {
    let operation = BlockOperation {
      guard let capabilities = capabilitiesOperation.capabilities else { return }
      completion(capabilities)
    }
    operation.addDependency(capabilitiesOperation)
    capabilitesQueue.addOperation(operation)
  }

  fileprivate static let downloadDeveloperTokenOperation = DownloadDeveloperTokenOperation()
  private static let requestCountryCodeOperation = RequestCountryCodeOperation()

  private static let musicAPIQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.addOperation(downloadDeveloperTokenOperation)
    queue.addOperation(requestCountryCodeOperation)
    return queue
  }()

  static func withAPIData(completion: @escaping (String, String) -> Void) {
    let operation = BlockOperation {
      guard let developerToken = downloadDeveloperTokenOperation.developerToken, let countryCode = requestCountryCodeOperation.countryCode else { return }
      completion(developerToken, countryCode)
    }
    operation.addDependency(downloadDeveloperTokenOperation)
    operation.addDependency(requestCountryCodeOperation)
    musicAPIQueue.addOperation(operation)
  }

  private static let downloadUserTokenOperation = DownloadUserTokenOperation()
  private static let musicUserAPIQueue: OperationQueue = {
    let queue = OperationQueue()
    downloadUserTokenOperation.addDependency(downloadDeveloperTokenOperation)
    queue.addOperation(downloadUserTokenOperation)
    return queue
  }()

  static func withUserAPIData(completion: @escaping (String, String, String) -> Void) {
    let operation = BlockOperation {
      guard let developerToken = downloadDeveloperTokenOperation.developerToken, let countryCode = requestCountryCodeOperation.countryCode, let userToken = downloadUserTokenOperation.userToken else { return }
      completion(developerToken, countryCode, userToken)
    }
    operation.addDependency(downloadUserTokenOperation)
    musicUserAPIQueue.addOperation(operation)
  }
}
