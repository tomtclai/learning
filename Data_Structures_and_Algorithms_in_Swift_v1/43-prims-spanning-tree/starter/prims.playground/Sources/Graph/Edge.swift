// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

public struct Edge<T> {
  
  public let source: Vertex<T>
  public let destination: Vertex<T>
  public let weight: Double?
}

extension Edge: Hashable {
  
  public var hashValue: Int {
    return "\(source)\(destination)\(weight ?? 0)".hashValue
  }
  
  static public func ==(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
    return lhs.source == rhs.source &&
      lhs.destination == rhs.destination &&
      lhs.weight == rhs.weight
  }
}
