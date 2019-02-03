
// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.
/*:
 # Priority Queue Challenges
 ## Challenge 1
 You know how to use a heap to construct a priority queue by conforming
 to the `Queue` protocol. Now construct a priority queue using an `Array`.
 */

public protocol Queue {
  associatedtype Element
  mutating func enqueue(_ element: Element) -> Bool
  mutating func dequeue() -> Element?
  var isEmpty: Bool { get }
  var peek: Element? { get }
}

//: [Next Challenge](@next)
