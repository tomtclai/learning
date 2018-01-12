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

private extension String {
  static let choice1 = "choice1"
  static let choice2 = "choice2"
  static let choice3 = "choice3"
  static let choice4 = "choice4"
}

struct Quiz {
  let song: Song
  let choices: [String]
  
  init(song: Song, choices: [String]) {
    self.song = song
    self.choices = choices
  }
  
  init?(queryItems: [URLQueryItem]) {
    guard let answer1 = queryItems.first(where: { queryItem in queryItem.name == .choice1 })?.value,
      let answer2 = queryItems.first(where: { queryItem in queryItem.name == .choice2 })?.value,
      let answer3 = queryItems.first(where: { queryItem in queryItem.name == .choice3 })?.value,
      let answer4 = queryItems.first(where: { queryItem in queryItem.name == .choice4 })?.value else { return nil }
    self.choices = [answer1, answer2, answer3, answer4]
    
    guard let song = Song(queryItems: queryItems) else { return nil }
    self.song = song
  }
  
  var queryItems: [URLQueryItem] {
    var items: [URLQueryItem] = song.queryItems
    items.append(URLQueryItem(name: .choice1, value: choices[0]))
    items.append(URLQueryItem(name: .choice2, value: choices[1]))
    items.append(URLQueryItem(name: .choice3, value: choices[2]))
    items.append(URLQueryItem(name: .choice4, value: choices[3]))
    return items
  }
}
