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
    var last: Node<Value>?
    var next: Node<Value>?
    
    while current != nil {
        next = current?.next
        current?.next = last
        last = current
        current = next
    }
    
    head = oldTail
    tail = oldHead
  }
}

var list = LinkedList<Int>()
list.push(1)
list.push(2)
list.push(3)
list.push(4)
list.push(5)
list.push(6)
list


list.reverse()
list
//: [Next Challenge](@next)
