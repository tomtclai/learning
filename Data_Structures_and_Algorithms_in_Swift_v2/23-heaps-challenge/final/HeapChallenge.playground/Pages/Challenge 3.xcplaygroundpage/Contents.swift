// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.
/*:
 [Previous Challenge](@previous)
 
 ## Challenge 2:
 
 See solutions chapter.
 
 ## Challenge 3:

 Write a method that combines two heaps together.
 
 Following function added in **Heap.swift**.
 ```
 mutating public func merge(heap: Heap) {
   elements = elements + heap.elements
   buildHeap()
 }
 ```
 */

let elements = [21, 10, 18, 5, 3, 100, 1]
let elements2 = [8, 6, 20, 15, 12, 11]
var heap = Heap(sort: <, elements: elements)
var heap2 = Heap(sort: <, elements: elements2)

heap.merge(heap: heap2)
print(heap)

//: [Next Challenge](@next)
