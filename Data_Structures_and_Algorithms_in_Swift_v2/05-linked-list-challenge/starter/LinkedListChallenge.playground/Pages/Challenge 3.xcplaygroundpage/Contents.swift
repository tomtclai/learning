// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.
/*:
 [Previous Challenge](@previous)
 ## Challenge 3:
 Create a function that reverses a linked list
 */

extension LinkedList {
    
  mutating func reverse() {
    // 1 > 2 > 3
    // 3 > 2 > 1   // l2.push(l1.pop())
    
    // nil < 1 < 2 < 3  // last, current, next
    // var oldHead = head
    // var oldTail = tail
    // var current = head
    // var last = nil
    // while current not nil
    //    var next = current.next
    //    current.next = last
    //    last = current
    //    current = next
    
    let oldHead = head
    let oldTail = tail
    var current = head
    var last: Node<Value>? = nil
    
    while current != nil {
        let next = current?.next
        current?.next = last
        last = current
        current = next
    }
    
    head = oldTail
    tail = oldHead
  }
}


//: [Next Challenge](@next)
