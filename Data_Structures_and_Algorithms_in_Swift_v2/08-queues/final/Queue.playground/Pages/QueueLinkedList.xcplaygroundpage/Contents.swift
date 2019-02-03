// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

public class QueueLinkedList<T>: Queue {
  
  private var list = DoublyLinkedList<T>()
  public init() {}

  public func enqueue(_ element: T) -> Bool {
    list.append(element)
    return true
  }
  
  public func dequeue() -> T? {
    guard !list.isEmpty, let element = list.first else {
      return nil
    }
    return list.remove(element)
  }
  
  public var peek: T? {
    return list.first?.value
  }
  
  public var isEmpty: Bool {
    return list.isEmpty
  }
}

extension QueueLinkedList: CustomStringConvertible {
  
  public var description: String {
    return String(describing: list)
  }
}

var queue = QueueLinkedList<String>()
queue.enqueue("Ray")
queue.enqueue("Brian")
queue.enqueue("Eric")
queue
queue.dequeue()
queue
queue.peek
