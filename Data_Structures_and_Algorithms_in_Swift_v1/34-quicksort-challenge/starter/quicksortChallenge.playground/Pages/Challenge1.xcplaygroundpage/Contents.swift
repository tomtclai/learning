/*:
 # Challenge 1
 
 Implement Quick Sort iteratively. Choose any partition strategy you learned in this chapter.
 */
// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

public func quicksortIterativeLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
  // Insert Solution Here
}

var list = [12, 0, 3, 9, 2, 21, 18, 27, 1, 5, 8, -1, 8]
quicksortIterativeLomuto(&list, low: 0, high: list.count - 1)
print(list)

