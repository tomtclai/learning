//: [Previous](@previous)

/*:
 # Challenge 5:
 ## Create a function that removes all occurrences of a specific element from a Linked List.
 https://docs.google.com/document/d/1CT99avP0nAFW_kUKjY8_u6tsbkvPb9mZtt70xSS8zTI/edit#
 */

extension LinkedList where Value: Equatable {
    mutating func removeAll(_ value: Value) {
        // deleting head
        // change the head
        var head = self.head
        while head?.value == value {
            head = head?.next // basically pop()
            if head == nil {
                tail = nil
            }
        }
        // deleting middle
        var prev = head?.next
        var curr = head?.next?.next
        while curr != nil {
            if curr!.value == value {
                // change prev.next to curr.next
                prev?.next = curr?.next
                curr = prev?.next?.next
            } else {
                prev = curr
                curr = curr?.next
            }
        }
        // deleting tail
        // change prev.next to curr.next
        // change tail
    }
}


//: [Next](@next)
