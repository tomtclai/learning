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

struct Song: Decodable {
  let title: String
  let artist: String
  let id: String
  let artworkUrl: URL
  
  init(title: String) {
    self.title = title
    self.artist = "Artist name"
    self.id = "0"
    self.artworkUrl = URL(string: "http://temp.com")!
  }
  
  init?(queryItems: [URLQueryItem]) {
    guard let title = queryItems.first(where: { queryItem in queryItem.name == Song.CodingKeys.title.stringValue })?.value,
      let artist = queryItems.first(where: { queryItem in queryItem.name == Song.CodingKeys.artist.stringValue })?.value,
      let id = queryItems.first(where: { queryItem in queryItem.name == Song.CodingKeys.id.stringValue })?.value,
      let artworkUrlString = queryItems.first(where: { queryItem in queryItem.name == Song.CodingKeys.artworkUrl.stringValue })?.value else { return nil }
    self.title = title
    self.artist = artist
    self.id = id
    
    // TODO: replace {w} and {h} with the size we want to get
    guard let artworkUrl = URL(string: artworkUrlString) else { return nil }
    self.artworkUrl = artworkUrl
  }
  
  var queryItems: [URLQueryItem] {
    var items: [URLQueryItem] = []
    items.append(URLQueryItem(name: Song.CodingKeys.title.stringValue, value: title))
    items.append(URLQueryItem(name: Song.CodingKeys.artist.stringValue, value: artist))
    items.append(URLQueryItem(name: Song.CodingKeys.id.stringValue, value: id))
    items.append(URLQueryItem(name: Song.CodingKeys.artworkUrl.stringValue, value: artworkUrl.absoluteString))
    return items
  }
}
