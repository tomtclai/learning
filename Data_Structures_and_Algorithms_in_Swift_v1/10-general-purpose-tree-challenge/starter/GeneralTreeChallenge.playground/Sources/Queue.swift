// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

public struct Queue<T> {
  
  private var leftStack: [T] = []
  private var rightStack: [T] = []
  
  public init() {}
  
  public var isEmpty: Bool {
    return leftStack.isEmpty && rightStack.isEmpty
  }
  
  public var peek: T? {
    return !leftStack.isEmpty ? leftStack.last : rightStack.first
  }
  
  public private(set) var count = 0
  @discardableResult public mutating func enqueue(_ element: T) -> Bool {
    count += 1
    rightStack.append(element)
    return true
  }
  
  public mutating func dequeue() -> T? {
    if leftStack.isEmpty {
      leftStack = rightStack.reversed()
      rightStack.removeAll()
    }
    
    let value = leftStack.popLast()
    if value != nil {
      count -= 1
    }
    return value
  }
}
