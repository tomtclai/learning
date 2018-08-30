/*:
 # Challenge 3

 You are playing a game of Monopoly with your friends. The problem is you all always forget whose turn it is! Create a Monopoly organizer that always tells you whose turn it is! Below is a protocol you can conform to:
 */
public protocol BoardGameManager {
    
  associatedtype Player
  mutating func nextPlayer() -> Player?
}

extension QueueArray: BoardGameManager {
    
  public typealias Player = T
  
  public mutating func nextPlayer() -> T? {
    // Solution Here
    return nil
  }
}

//: [Next](@next)
