import Foundation
struct FlashCard: Identifiable {
  var card: Challenge
  let id = UUID()
  var isActive = true
}


extension FlashCard: Equatable {
  static func == (lhs: FlashCard, rhs: FlashCard) -> Bool {
    return lhs.card.question == rhs.card.question
        && lhs.card.answer == rhs.card.answer
  }
}
