// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.
/*:
 [Previous Challenge](@previous)
 ## Challenge 5:
 Create a function that removes all occurrences of a specific element from a Linked List.
 */

extension LinkedList where Value: Equatable {
  
  mutating func removeAll(_ value: Value) {
    while let head = self.head, head.value == value {
      self.head = head.next
    }
    var prev = head
    var current = head?.next
    while let currentNode = current {
      if currentNode.next == nil {
        tail
      }
      guard currentNode.value != value else {
        prev?.next = currentNode.next
        current = prev?.next
        continue
      }
      prev = current
      current = current?.next
    }
    tail = prev
  }
}

example(of: "deleting duplicate nodes") {
  var list = LinkedList<Int>()
  list.push(3)
  list.push(2)
  list.push(2)
  list.push(1)
  list.push(1)
  
  list.removeAll(3)
  print(list)
}

