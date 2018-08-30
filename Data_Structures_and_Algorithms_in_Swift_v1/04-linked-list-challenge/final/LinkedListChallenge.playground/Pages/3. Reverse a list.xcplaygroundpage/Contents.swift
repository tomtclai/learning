//: [Previous](@previous)

/*:
 # Challenge 3:
 ## Create a function that reverses a linked list
 */

extension LinkedList {
    
  mutating func reverse() {
    var prev = head
    var current = head?.next
    prev?.next = nil
    
    while current != nil {
      let next = current?.next
      current?.next = prev
      prev = current
      current = next
    }
    head = prev
  }
}

example(of: "reversing a list") {
  var list = LinkedList<Int>()
  list.push(3)
  list.push(2)
  list.push(1)
  
  print("Original list: \(list)")
  list.reverse()
  print("Reversed list: \(list)")
}

//: [Next](@next)
