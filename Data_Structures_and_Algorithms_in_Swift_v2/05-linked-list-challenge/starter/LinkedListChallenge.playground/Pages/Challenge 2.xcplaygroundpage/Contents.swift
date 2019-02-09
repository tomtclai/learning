// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.
/*:
 [Previous Challenge](@previous)
 ## Challenge 2:
 Create a function that returns the middle node of a Linked List.
 */

func getMiddle<T>(_ list: LinkedList<T>) -> Node<T>? {
    // fast and slow pointer
    // one takes 2 steps at a time
    // one takes 1 step at a time
    // when the fast pointer hits the end the slow one is in the middle
    // neeed to worry about.... 1 node lists, no node lists
    // assumming there is no cycles
    
    // 1 > 2 > 3 > 4
    // 1
    // 1 > 2
    var fast = list.head?.next // fast -> 2
    var slow = list.head // slow -> 1
    
    while fast != nil { //
        fast = fast?.next?.next // fast -> nil
        slow = slow?.next // slow -> 2
    }
    
    return slow
}


var list = LinkedList<Int>()
list.append(2)
list.append(5)
list.append(7)
getMiddle(list)
//: [Next Challenge](@next)
