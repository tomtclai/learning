//: [Previous](@previous)
/*:
 # Challenge 3
 
 Add a method to `Graph` to detect if a **directed** graph has a cycle.
 */
// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

extension Graph {
  
  func hasCycle(from source: Vertex<Element>) -> Bool  {
    var pushed: Set<Vertex<Element>> = []
    return hasCycle(from: source, pushed: &pushed)
  }
  
  func hasCycle(from source: Vertex<Element>,
                pushed: inout Set<Vertex<Element>>) -> Bool {
    // TODO: Fill in Solution Here.
    return false
  }
}

//: ![sampleGraph2](sampleGraph2.png)

let graph = AdjacencyList<String>()
let a = graph.createVertex(data: "A")
let b = graph.createVertex(data: "B")
let c = graph.createVertex(data: "C")
let d = graph.createVertex(data: "D")

graph.add(.directed, from: a, to: b, weight: nil)
graph.add(.directed, from: a, to: c, weight: nil)
graph.add(.directed, from: c, to: a, weight: nil)
graph.add(.directed, from: b, to: c, weight: nil)
graph.add(.directed, from: c, to: d, weight: nil)

print(graph)
print(graph.hasCycle(from: a))
