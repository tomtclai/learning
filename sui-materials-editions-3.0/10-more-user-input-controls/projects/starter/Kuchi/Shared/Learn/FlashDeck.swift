import Foundation
class FlashDeck {
  @Published var cards: [FlashCard]

  init(from words: [Challenge]) {
    self.cards = words.map {
      FlashCard(card: $0)
    }
  }
}
