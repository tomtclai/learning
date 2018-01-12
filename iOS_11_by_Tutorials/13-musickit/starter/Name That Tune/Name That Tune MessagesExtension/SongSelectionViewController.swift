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
import Messages

protocol SongSelectionViewControllerDelegate: class {
  func songSelectionViewController(_ controller: SongSelectionViewController, didSelectTitle title: String, correctly isCorrect: Bool, timeTaken time: TimeInterval, correctSong song: Song)
}

class SongSelectionViewController: UIViewController {
	static let storyboardIdentifier = "SongSelectionViewController"

	@IBOutlet var answersStackView: UIStackView!
	@IBOutlet var answerButtons: [UIButton]!
  @IBOutlet var playPauseButton: UIButton!

	private let bottomMargin: CGFloat = 15

	weak var delegate: SongSelectionViewControllerDelegate?
	var showAsActive: Bool = true
	var quiz: Quiz?

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let quiz = quiz else { fatalError("Quiz not set before loading SongSelectionViewController") }

		for (index, button) in answerButtons.enumerated() {
			button.setTitle(quiz.choices[index], for: .normal)
		}

		if showAsActive == false {
			disableButtons()
		}
	}

	private func disableButtons() {
		answerButtons.forEach { button in
			button.isEnabled = false
			button.backgroundColor = .clear
		}
	}

	func getHeight() -> CGFloat {
		return answersStackView.frame.maxY + bottomMargin
	}

	@IBAction func playPauseTapped(_ sender: UIButton) {
		// TODO: play the song for the quiz
	}

	@IBAction func answerTapped(_ sender: UIButton) {
		guard let delegate = delegate, let chosenTitle = sender.title(for: .normal), let correctSong = quiz?.song else { return }
		// TODO: send the time taken
		disableButtons()
		let correctAnswer: Bool
		if chosenTitle == correctSong.title {
			correctAnswer = true
		} else {
			correctAnswer = false
		}
		delegate.songSelectionViewController(self, didSelectTitle: chosenTitle, correctly: correctAnswer, timeTaken: 0, correctSong: correctSong)
	}
}
