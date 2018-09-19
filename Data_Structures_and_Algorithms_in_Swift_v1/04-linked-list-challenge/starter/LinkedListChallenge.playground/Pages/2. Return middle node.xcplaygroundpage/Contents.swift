//: [Previous](@previous)

/*:
 # Challenge 2:
 ## Create a function that returns the middle node of a Linked List.
 */

func getMiddle<T>(_ list: LinkedList<T>) -> Node<T>? {
  var fast = list.head
  var slow = list.head
  while fast != nil {
    fast = fast?.next?.next
    slow = slow?.next
  }

  return slow
}

//: [Next](@next)

example(of: "Challenge 2") {
  var list = LinkedList<Int>()
  list.push(4)
  list.push(3)
  list.push(2)
  list.push(1)


  print("middle is \(String(describing: getMiddle(list))) ")
}
