/*:
 # Challenge 2
 
 In this chapter we went over an iterative implementation of Depth-first search. Now write a recursive implementation.
 */
// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

extension Graph {
  
  func depthFirstSearch(from source: Vertex<Element>)
    -> [Vertex<Element>] {
      var visited: [Vertex<Element>] = []
      var pushed: Set<Vertex<Element>> = []
      depthFirstSearch(from: source, visited: &visited, pushed: &pushed)
      return visited
  }
  
  func depthFirstSearch(from source: Vertex<Element>,
                        visited: inout [Vertex<Element>],
                        pushed: inout Set<Vertex<Element>>) {
    pushed.insert(source)
    visited.append(source)
    
    let neighbors = edges(from: source)
    for edge in neighbors {
      if !pushed.contains(edge.destination) {
        depthFirstSearch(from: edge.destination, visited: &visited, pushed: &pushed)
      }
    }
  }
}

//: ![sampleGraph](sampleGraph.png)

let graph = AdjacencyList<String>()
let a = graph.createVertex(data: "A")
let b = graph.createVertex(data: "B")
let c = graph.createVertex(data: "C")
let d = graph.createVertex(data: "D")
let e = graph.createVertex(data: "E")
let f = graph.createVertex(data: "F")
let g = graph.createVertex(data: "G")
let h = graph.createVertex(data: "H")

graph.add(.undirected, from: a, to: b, weight: nil)
graph.add(.undirected, from: a, to: c, weight: nil)
graph.add(.undirected, from: a, to: d, weight: nil)
graph.add(.undirected, from: b, to: e, weight: nil)
graph.add(.undirected, from: c, to: g, weight: nil)
graph.add(.undirected, from: e, to: f, weight: nil)
graph.add(.undirected, from: e, to: h, weight: nil)
graph.add(.undirected, from: f, to: g, weight: nil)
graph.add(.undirected, from: f, to: c, weight: nil)

let vertices = graph.depthFirstSearch(from: a)
vertices.forEach { vertex in
  print(vertex)
}

//: [Next](@next)
