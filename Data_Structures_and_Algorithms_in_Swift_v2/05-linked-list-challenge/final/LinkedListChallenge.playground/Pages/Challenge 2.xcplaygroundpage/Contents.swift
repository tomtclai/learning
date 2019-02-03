// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.
/*:
 [Previous Challenge](@previous)
 ## Challenge 2:
 Create a function that returns the middle node of a Linked List.
 */

func getMiddle<T>(_ list: LinkedList<T>) -> Node<T>? {
  var slow = list.head
  var fast = list.head
  
  while let nextFast = fast?.next {
    fast = nextFast.next
    slow = slow?.next
  }
  
  return slow
}

example(of: "getting the middle node") {
  var list = LinkedList<Int>()
  list.push(3)
  list.push(2)
  list.push(1)
  
  print(list)
  
  if let middleNode = getMiddle(list) {
    print(middleNode)
  }
}

//: [Next Challenge](@next)
