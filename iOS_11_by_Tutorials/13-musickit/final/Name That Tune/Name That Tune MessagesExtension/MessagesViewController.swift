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
import GameplayKit

class MessagesViewController: MSMessagesAppViewController {
	var transcriptController: SongSelectionViewController?

    override func willBecomeActive(with conversation: MSConversation) {
		super.willBecomeActive(with: conversation)

		AuthorizationManager.authorize(completionIfAuthorized: {
			self.presentViewController(for: conversation, with: self.presentationStyle)
		}, ifUnauthorized: {
			self.addController(self.authErrorViewController)
		})
	}

	private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
		let controller: UIViewController

		if presentationStyle == .transcript {
			guard let selectedMessage = conversation.selectedMessage,
				let components = URLComponents(url: selectedMessage.url!, resolvingAgainstBaseURL: false),
				let queryItems = components.queryItems,
				let quiz = Quiz(queryItems: queryItems) else { fatalError("Quiz could not be constructed") }

			let isMine = conversation.selectedMessageIsMine
			if isMine == false, let answer = UserDefaults.standard.object(forKey: quiz.song.id) as? Bool {
				let answerController = songAnswerViewController
				answerController.correctSong = quiz.song
				answerController.isCorrect = answer
				controller = answerController
			} else {
				let songController = songSelectionViewController
				if isMine {
					songController.showAsActive = false
				}
				songController.quiz = quiz
				transcriptController = songController
				controller = songController
			}
		} else {
			controller = songListController
		}

		addController(controller)
	}

	override func contentSizeThatFits(_ size: CGSize) -> CGSize {
		if presentationStyle == .transcript, let controller = transcriptController {
			return CGSize(width: size.width, height: controller.getHeight())
		} else {
			return super.contentSizeThatFits(size)
		}
	}

	private lazy var songListController: SongListViewController = {
		guard let controller = self.storyboard?.instantiateViewController(withIdentifier: SongListViewController.storyboardIdentifier) as? SongListViewController else {
			fatalError("Unable to instantiate SongListViewController")
		}
		controller.delegate = self
		return controller
	}()

	private lazy var songSelectionViewController: SongSelectionViewController = {
		guard let controller = self.storyboard?.instantiateViewController(withIdentifier: SongSelectionViewController.storyboardIdentifier) as? SongSelectionViewController else {
			fatalError("Unable to instantiate SongSelectionViewController")
		}
		controller.delegate = self
		return controller
	}()

	private lazy var songAnswerViewController: SongAnswerViewController = {
		guard let controller = self.storyboard?.instantiateViewController(withIdentifier: SongAnswerViewController.storyboardIdentifier) as? SongAnswerViewController else {
			fatalError("Unable to instantiate SongAnswerViewController")
		}
		return controller
	}()

	private lazy var authErrorViewController: UIViewController = {
		guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "AuthErrorViewController") else {
			fatalError("Unable to instantiate AuthErrorViewController")
		}
		return controller
	}()
}

extension MessagesViewController: SongListViewControllerDelegate {
	func songListViewController(_ controller: SongListViewController, didSelect song: Song, wrongTitles: [String]) {
		guard let conversation = activeConversation else { fatalError("No active conversation") }

		var allTitles = wrongTitles
		allTitles.append(song.title)
		allTitles = (allTitles as NSArray).shuffled() as! [String]
		let quiz = Quiz(song: song, choices: allTitles)
		var components = URLComponents()
		components.queryItems = quiz.queryItems

		let fallbackLayout = MSMessageTemplateLayout()
		fallbackLayout.caption = "Install the app to play Name That Tune (iOS 11 required)!"

		let liveLayout = MSMessageLiveLayout(alternateLayout: fallbackLayout)
		let message = MSMessage()
		message.url = components.url
		message.layout = liveLayout
		message.summaryText = "Name this tune"

		conversation.insert(message) { error in
			if let error = error {
				print(error)
			}
		}

		dismiss()
	}
}

extension MessagesViewController: SongSelectionViewControllerDelegate {
	func songSelectionViewController(_ controller: SongSelectionViewController, didSelectTitle title: String, correctly isCorrect: Bool, timeTaken time: TimeInterval, correctSong song: Song) {
		guard let conversation = activeConversation else { fatalError("No active conversation") }

		let emoji: String
		let correctly: String
		if isCorrect {
			emoji = "✅"
			correctly = "correctly in \(time) seconds!"
		} else {
			emoji = "❌"
			correctly = "incorrectly"
		}
		let message = "\(emoji) $\(conversation.localParticipantIdentifier.uuidString) guessed \(song.title) \(correctly)"
    // Note: In the GM, this is still generating an error every time instead of sending the text. Radar has been filed.
		conversation.sendText(message) { error in
			if let error = error {
				print(error)
			}
		}

		guard let oldController = transcriptController else { fatalError("Old controller not found") }
		oldController.removeController()
		transcriptController = nil

		let controller = songAnswerViewController
		controller.correctSong = song
		controller.isCorrect = isCorrect
		self.addController(controller)
		UserDefaults.standard.set(isCorrect, forKey: song.id)

		requestPresentationStyle(.compact)
	}
}

extension MSConversation {
	var selectedMessageIsMine: Bool {
		get {
			guard let selectedMessage = self.selectedMessage else { return false }
			if selectedMessage.isPending || selectedMessage.senderParticipantIdentifier == self.localParticipantIdentifier {
				return true
			} else {
				return false
			}
		}
	}
}
