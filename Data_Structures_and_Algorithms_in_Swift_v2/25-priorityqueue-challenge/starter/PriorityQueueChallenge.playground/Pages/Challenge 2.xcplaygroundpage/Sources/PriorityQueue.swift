// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import Foundation

public struct PriorityQueue<Element: Equatable>: Queue {
  
  private var heap: Heap<Element>
  
  public init(sort: @escaping (Element, Element) -> Bool, elements: [Element] = []) {
    heap = Heap(sort: sort, elements: elements)
  }
  
  public var isEmpty: Bool {
    return heap.isEmpty
  }
  
  public var peek: Element? {
    return heap.peek()
  }
  
  public mutating func enqueue(_ element: Element) -> Bool {
    heap.insert(element)
    return true
  }
  
  public mutating func dequeue() -> Element? {
    return heap.remove()
  }
}
