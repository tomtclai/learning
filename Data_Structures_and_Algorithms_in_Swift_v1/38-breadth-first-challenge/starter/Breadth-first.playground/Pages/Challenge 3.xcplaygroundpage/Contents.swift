//: [Previous](@previous)
/*:
 # Challenge 3
 
 > Add a method to `Graph` to detect if a graph is disconnected.
 */
// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

extension Graph {
  
  func breadthFirstSearch(from source: Vertex<Element>) -> [Vertex<Element>] {
    var queue = QueueStack<Vertex<Element>>()
    var enqueued: Set<Vertex<Element>> = []
    var visited: [Vertex<Element>] = []
    
    queue.enqueue(source)
    enqueued.insert(source)
    
    while let vertex = queue.dequeue() {
      visited.append(vertex)
      let neighborEdges = edges(from: vertex)
      neighborEdges.forEach { edge in
        if !enqueued.contains(edge.destination) {
          queue.enqueue(edge.destination)
          enqueued.insert(edge.destination)
        }
      }
    }
    
    return visited
  }
}

extension Graph {
    
  func isDisconnected() -> Bool {
    // MARK: Add solution here.
    return true
  }
}


//: ![challenge3Sample](challenge3Sample.png)

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
graph.add(.undirected, from: e, to: h, weight: nil)
graph.add(.undirected, from: e, to: f, weight: nil)
graph.add(.undirected, from: f, to: g, weight: nil)
//graph.add(.undirected, from: a, to: e, weight: nil)

graph.isDisconnected()
