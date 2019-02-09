// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.
/*:
 [Previous Challenge](@previous)
 ## Challenge 5:
 Create a function that removes all occurrences of a specific element from a Linked List.
 */

extension LinkedList where Value: Equatable {
  
  mutating func removeAll(_ value: Value) {
    copyNodes()
    // 1 > 2 > 3 > 3 > 4
    //
    // v = 3
    // l > 2
    // c > 3
    var curr = head
    var last: Node<Value>? = nil
    while curr != nil {
        if (curr?.value == value) {
            // test: 1 > 1 > 1 > 1
            if curr === head {
                // the head is the value we want to remove
                pop()
                curr = curr?.next
                continue
            }
            
            last?.next = curr?.next
            curr = curr?.next
        } else {
            last = curr
            curr = curr?.next
        }
    }
    // if ( c == value) {
    //  l.n > c.n // skip current
    //  c = c.n
    // }
    // l = c
    // c = c.n
  }
}


var list = LinkedList<Int>()
list.push(1)
list.push(2)
list.push(3)
list.push(3)
list.push(3)
list.push(3)
list.push(3)
list.push(4)

var list2 = list
var list3 = list

list.removeAll(3)

list2.removeAll(1)

list3.removeAll(4)
