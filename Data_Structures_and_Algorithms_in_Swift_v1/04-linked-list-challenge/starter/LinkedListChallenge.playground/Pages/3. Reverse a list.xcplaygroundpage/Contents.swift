//: [Previous](@previous)

/*:
 # Challenge 3:
 ## Create a function that reverses a linked list
 */

extension LinkedList {
    
  mutating func reverse() {

    // 0 -> 1 -> 2 -> nil
    // prev curr next
    // prev<curr next
    //      prev curr next
    var prev = head
    var curr = head?.next
    head?.next = nil

    while curr != nil {
      let next = curr?.next
      curr?.next = prev
      prev = curr
      curr = next
    }
    var oldHead = head
    head = tail
    tail = oldHead
  }
}


//: [Next](@next)

example(of: "Challenge 3") {
  var list = LinkedList<Int>()
  list.push(3)
  list.push(2)
  list.push(1)

  print(list)
  list.reverse()
  print(list)
}
