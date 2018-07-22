/*:
 # Challenge 1

 You have learnt to use a heap to construct a priority queue by conforming to the `Queue` protocol. Now construct a priority queue using an `Array`.
 */

// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

public protocol Queue {
  associatedtype Element
  mutating func enqueue(_ element: Element) -> Bool
  mutating func dequeue() -> Element?
  var isEmpty: Bool { get }
  var peek: Element? { get }
}

public struct PriorityQueueArray<T: Equatable>: Queue {
  
  private var elements: [T] = []
  let sort: (Element, Element) -> Bool
  
  public init(sort: @escaping (Element, Element) -> Bool, elements: [Element] = []) {
    self.sort = sort
    self.elements = elements
    // insert here.
  }
  
  public var isEmpty: Bool {
    return false // insert here.
  }
  
  public var peek: T? {
    return nil // insert here.
  }
  
  public mutating func enqueue(_ element: T) -> Bool {
    return true // insert here.
  }
  
  public mutating func dequeue() -> T? {
    return nil // insert here.
  }
}

extension PriorityQueueArray: CustomStringConvertible {

  public var description: String {
    return String(describing: elements)
  }
}

var priorityQueue = PriorityQueueArray(sort: >, elements: [1,12,3,4,1,6,8,7])
print(priorityQueue)





