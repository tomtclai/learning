/*:
 # Challenge 1
 
 Write a function to find the `nth` smallest integer in an unsorted array. For example:
 
 ```
  let integers = [3, 10, 18, 5, 21, 100]
 ```
 If  `n = 3`, the result should be `10`.
 */
func getNthSmallestElement(n: Int, elements: [Int]) -> Int? {
  var heap = Heap(sort: <, elements: elements)
  var current = 1
  while !heap.isEmpty {
    let element = heap.remove()
    if current == n {
      return element
    }
    current += 1
  }
  return nil
}
//: [Next](@next)
