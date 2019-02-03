// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.
/*:
 [Previous Challenge](@previous)
 ## Challenge 4:
 Write a function to check if a given array is a min heap.
 */

func leftChildIndex(ofParentAt index: Int) -> Int {
  return (2 * index) + 1
}

func rightChildIndex(ofParentAt index: Int) -> Int {
  return (2 * index) + 2
}

func isMinHeap<Element: Comparable> (elements: [Element]) -> Bool {

  // Your code here
  
  return true
}

let elements = [1, 3, 12, 5, 10, 18, 21, 6, 8, 11, 15, 100, 20]
isMinHeap(elements: elements)

