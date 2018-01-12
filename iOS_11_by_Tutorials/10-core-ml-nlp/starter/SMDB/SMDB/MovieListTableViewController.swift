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

class MovieListTableViewController: UITableViewController {

  var movies: [String]  { return ReviewsManager.instance.reviewsByMovie.keys.sorted() }
  var selectedMovie: String?

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let movie = movies[indexPath.row]
    let reviews = ReviewsManager.instance.reviewsByMovie[movie]!

    let sentiments = reviews.flatMap { $0.sentiment }
    let sentimentRating: String
    if sentiments.isEmpty {
      sentimentRating = ""
    } else {
      let averageSentiment = sentiments.reduce(0.0) { $0 + Double($1) / Double(sentiments.count) }
      switch averageSentiment {
      case ..<0.33:
        sentimentRating = "🍅"
      case ..<0.66:
        sentimentRating = "🍅🍅"
      default:
        sentimentRating = "🍅🍅🍅"
      }
    }

    cell.textLabel?.text = movie + " (\(reviews.count)) \(sentimentRating)"

    return cell
  }

  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    selectedMovie = movies[indexPath.row]
    return indexPath
  }

  override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
    selectedMovie = nil
    return indexPath
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "listReviews" else { return }
    let reviewController = segue.destination as! ReviewsTableViewController
    reviewController.baseReviews = ReviewsManager.instance.reviewsByMovie[selectedMovie!]!
  }
}
