//
//public class AdjacencyMatrix<T: Hashable>: Graph {
//
//  
//  private var vertices: [Vertex<T>] = []
//  private var weights: [[Double?]] = []
//  
//  public init() {}
//  public func createVertex(data: T) -> Vertex<T> {
//    let vertex = Vertex(index: vertices.count, data: data)
//    vertices.append(vertex)
//    for i in 0..<weights.count {
//        weights[i].append(nil)
//    }
//    let row = [Double?](repeating: nil, count: vertices.count)
//    weights.append(row)
//    return vertex
//  }
//  
//  public func addUndirectedEdge(between source: Vertex<T>, and destination: Vertex<T>, weight: Double?) {
//    addDirectedEdge(from: source, to: destination, weight: weight)
//    addDirectedEdge(from: destination, to: source, weight: weight)
//  }
//  
//  public func add(_ edge: EdgeType, from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
//    switch edge {
//    case .directed:
//      addDirectedEdge(from: source, to: destination, weight: weight)
//    case .undirected:
//      addUndirectedEdge(between: source, and: destination, weight: weight)
//    }
//  }
//  
//  public func addDirectedEdge(from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
//    weights[source.index][destination.index] = weight
//  }
//  
//  public func edges(from source: Vertex<T>) -> [Edge<T>] {
//    var edges: [Edge<T>] = []
//    for column in 0..<weights.count {
//      if let weight = weights[source.index][column] {
//        edges.append(Edge(source: source, destination: vertices[column], weight: weight))
//      }
//    }
//    return edges
//  }
//  
//  public func weight(from source: Vertex<T>, to destination: Vertex<T>) -> Double? {
//    return weights[source.index][destination.index]
//  }
//}
//
//extension AdjacencyMatrix: CustomStringConvertible {
//  public var description: String {
//    let verticesDescription = vertices.map { "\($0)"}.joined(separator: "\n")
//    
//    var grid: [String] = []
//    for i in 0..<weights.count {
//      var row = ""
//      for j in 0..<weights.count {
//        if let value = weights[i][j] {
//          row += "\(value)\t\t"
//        } else {
//          row += "ø\t\t"
//        }
//      }
//      grid.append(row)
//    }
//    let edgesDescription = grid.joined(separator: "\n")
//    return "\(verticesDescription) \n\n \(edgesDescription)"
//  }
//}
