// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.
/*:
 # Linked List Challenges
 ## Challenge 1:
 Create a function that prints out the elements of a Linked List in reverse order.
 */

func printInReverse<T>(_ list: LinkedList<T>) {
    var mutableList2 = LinkedList<T>()
    var mutableList = list
    while !mutableList.isEmpty {
        mutableList2.push(mutableList.pop()!)
    }
    
    var current = mutableList2.head
    while current != nil {
        print(current!.value)
        current = current?.next
    }

//    print(mutableList2)
}

var list = LinkedList<Int>()

list.push(1)
list.push(2)
list.push(3)
list.push(31203)


print(list)

printInReverse(list)


//: [Next Challenge](@next)
