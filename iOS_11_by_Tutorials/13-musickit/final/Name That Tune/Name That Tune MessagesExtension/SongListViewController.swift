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

private extension String {
  static let cellIdentifier = "songCell"
}

protocol SongListViewControllerDelegate: class {
  func songListViewController(_ controller: SongListViewController, didSelect song: Song, wrongTitles: [String])
}

class SongListViewController: UITableViewController {
  static let storyboardIdentifier = "SongListViewController"
  weak var delegate: SongListViewControllerDelegate?
  private var songs: [Song] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Song.top40Songs { songs, error in
      if let songs = songs {
        self.songs = songs
      }
    }
  }
}

// MARK: - UITableView delegate/data source

extension SongListViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return songs.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: .cellIdentifier, for: indexPath)
    cell.textLabel?.text = songs[indexPath.row].title
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if let delegate = delegate {
      var remainingSongs = songs
      remainingSongs.remove(at: indexPath.row)
      var index = Int(arc4random_uniform(UInt32(remainingSongs.endIndex)))
      let wrongChoice1 = remainingSongs.remove(at: index)
      index = Int(arc4random_uniform(UInt32(remainingSongs.endIndex)))
      let wrongChoice2 = remainingSongs.remove(at: index)
      index = Int(arc4random_uniform(UInt32(remainingSongs.endIndex)))
      let wrongChoice3 = remainingSongs.remove(at: index)
      
      delegate.songListViewController(self, didSelect: songs[indexPath.row], wrongTitles: [wrongChoice1.title, wrongChoice2.title, wrongChoice3.title])
    }
  }
}
