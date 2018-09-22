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

/**
 * MeetupRequestManager is responsible to dispatch requests, parse responses
 * and return objects fully formatted for UI.
 **/
class MeetupRequestManager: NetworkRequestManager {
  
  /// Dispatches a requet to get meetup groups. Upon success in the completion block returns a valid, non-nil array of meetups which can be empty. If fails, meetups array is nil. Check the error parameter for possible error messages.
  func fetchMeetupGroupsWithModel(model requestModel: MeetupGroupRequestModel, completion: @escaping (_ meetups: [Meetup]?, _ error: Error?) -> Void) {
    print("MeetupRequestManager made a request for location (lat: \(requestModel.latitude), lon: \(requestModel.longitude))")
    let request = MeetupRequestFactory().URLRequestForGroupSearchWithModel(requestModel)
    dispatchRequest(request) { (data, error) -> Void in
      guard let data = data else {
        print("MeetupRequestManager failed to get valid response: \(String(describing: error?.localizedDescription))")
        self.performBlockOnTheMainThread({ () -> Void in
          completion(nil, error)
        })
        return
      }
      let binder = MeetupGroupResponseBinder()
      let meetups = binder.bindResponse(data)
      if meetups.isEmpty {
        if let rawResponse = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
          print(rawResponse)
        }
      }
      self.performBlockOnTheMainThread({ () -> Void in
        completion(meetups, nil)
      })
    }
  }
}
