// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

public struct Stack<Element> {
  
  private var storage: [Element] = []
  
  public init() { }
  
  public init(_ elements: [Element]) {
    storage = elements
  }
  
  public mutating func push(_ element: Element) {
    storage.append(element)
  }
  
  @discardableResult
  public mutating func pop() -> Element? {
    return storage.popLast()
  }
  
  public func peek() -> Element? {
    return storage.last
  }
  
  public var isEmpty: Bool {
    return peek() == nil
  }
}

extension Stack: CustomStringConvertible {
  public var description: String {
    let topDivider = "----top----\n"
    let bottomDivider = "\n-----------"
    
    let stackElements = storage
      .map { "\($0)" }
      .reversed()
      .joined(separator: "\n")
    return topDivider + stackElements + bottomDivider
  }
}

extension Stack: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Element...) {
    storage = elements
  }
}

