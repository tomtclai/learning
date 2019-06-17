import Foundation

public struct Edge<T> {
  public let source: Vertex<T>
  public let destination: Vertex<T>
  public let weight: Double?
}
