// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.
/*:
 # Stack Challenges
 
 ## Challenge 1
 Print a linked list in reverse without using recursion. Given a linked list,
 print the nodes in reverse order. You should not use recursion to solve
 this problem.
 */

let list: LinkedList<Int> = {
  var list = LinkedList<Int>()
  list.push(3)
  list.push(2)
  list.push(1)
  return list
}()

// Your code here
func printInReverse<T>(_ list: LinkedList<T>) {
    // l1 = 3 > 2 > 1
    var mutableList = list
    var reversedList = LinkedList<T>()
    
    while let value = mutableList.pop() {
        reversedList.push(value)
    }
    // l2.push(l1.pop())
    // l2.push(l1.pop())
    // l2.push(l1.pop())
    //
    
    while let value = reversedList.pop() {
        print(value)
    }
    // l2.pop()
}


list

printInReverse(list)

//: [Next Challenge](@next)
