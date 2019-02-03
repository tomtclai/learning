// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.
//: [Previous Challenge](@previous)
/*:
 # Challenge 2
 
 Vincent has three friends, Chesley, Ruiz, and Patrick. Ruiz has friends Ray, Sun, and a mutual friend with Vincent's. Patrick is friends with Cole, and Kerry. Cole is friends with Ruiz and Vincent. Create an adjacency list that represents this friendship graph. Which mutual friend do Ruiz and Vincent share?
 */
// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

let graph = AdjacencyList<String>()

let vincent = graph.createVertex(data: "vincent")
let chesley = graph.createVertex(data: "chesley")
let ruiz = graph.createVertex(data: "ruiz")
let patrick = graph.createVertex(data: "patrick")
let ray = graph.createVertex(data: "ray")
let sun = graph.createVertex(data: "sun")
let cole = graph.createVertex(data: "cole")
let kerry = graph.createVertex(data: "kerry")

graph.add(.undirected, from: vincent, to: chesley, weight: 0)
graph.add(.undirected, from: vincent, to: ruiz, weight: 0)
graph.add(.undirected, from: vincent, to: patrick, weight: 0)
graph.add(.undirected, from: ruiz, to: ray, weight: 0)
graph.add(.undirected, from: ruiz, to: sun, weight: 0)
graph.add(.undirected, from: patrick, to: cole, weight: 0)
graph.add(.undirected, from: patrick, to: kerry, weight: 0)
graph.add(.undirected, from: cole, to: ruiz, weight: 0)
graph.add(.undirected, from: cole, to: vincent, weight: 0)

print(graph)
print("Ruiz and Vincent both share a friend name Cole")
