// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

public struct Edge<T> {
  
  public let source: Vertex<T>
  public let destination: Vertex<T>
  public let weight: Double?
}

extension Edge: Hashable where T: Hashable {}
extension Edge: Equatable where T: Equatable {}
