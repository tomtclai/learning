import Foundation
class LearningStore: ObservableObject {

  // 1
  @Published var deck: FlashDeck

  // 2
  @Published var card: FlashCard?

  // 3
  @Published var score = 0

  // 4
  init(deck: [Challenge]) {
    self.deck = FlashDeck(from: deck)
    self.card = getNextCard()
  }

  // 5
  func getNextCard() -> FlashCard? {
    guard let card = self.deck.cards.last else {
      return nil
    }

    self.card = card
    self.deck.cards.removeLast()

    return self.card
  }
}
