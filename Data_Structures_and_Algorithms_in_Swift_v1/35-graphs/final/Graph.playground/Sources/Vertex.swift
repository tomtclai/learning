// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

public struct Vertex<T> {
  
  public let index: Int
  public let data: T
}

extension Vertex: Hashable {
  
  public var hashValue: Int {
    return index.hashValue
  }
  
  public static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
    return lhs.index == rhs.index
  }
}

extension Vertex: CustomStringConvertible {
  
  public var description: String {
    return "\(index): \(data)"
  }
}
